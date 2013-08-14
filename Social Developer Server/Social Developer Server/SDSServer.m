//
//  SDSServer.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SDSServer.h"
#import "GCDAsyncSocket.h"
#import "RoutingHTTPServer.h"
#import "SDSAppDelegate.h"
#import "CDASQLiteDataStore.h"
#import "NSDate+CDAStringRepresentation.h"
#import "HTTPStatusCodes.h"
#import "RouteResponse+IPAddress.h"
#import "Session+Authentication.h"

#import "SDSDataModels.h"

@implementation SDSServer (Authentication)

-(void)authenticateUsingRequest:(RouteRequest *)request
                       response:(RouteResponse *)response
                     completion:(void (^)(APIAppSession *apiAppSession, Session *session))completionBlock
{
    // get the authentication from HTTP header
    
    NSString *authorizationString = request.headers[@"Authorization"];
    
    // authorization header is "SDS <apiAppToken> <userToken>"
    NSArray *parsedAuthStringArray = [authorizationString componentsSeparatedByString:@" "];
    
    // invalid authorization header
    if (!parsedAuthStringArray ||
        !(parsedAuthStringArray.count == 3 || parsedAuthStringArray.count == 2) ||
        ![parsedAuthStringArray[0] isEqualToString:@"SDS"]) {
        
        if (completionBlock) {
            completionBlock(nil, nil);
        }
        
        return;
    }
    
    // get API app token
    NSString *apiAppToken = parsedAuthStringArray[1];
    
    [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"APIAppSessionWithToken" substitutionVariables:@{@"TOKEN": apiAppToken} completion:^(NSManagedObject *fetchedObject)
    {
        APIAppSession *apiAppSession = (APIAppSession *)fetchedObject;
        
        // must always have APIAppSession
        if (!apiAppSession) {
            
            if (completionBlock) {
                completionBlock(nil, nil);
            }
            
            return;
        }
        
        // no user authentication
        if (parsedAuthStringArray.count == 2) {
            
            if (completionBlock) {
                completionBlock(apiAppSession, nil);
            }
            
            return;
        }
        
        NSString *sessionToken = parsedAuthStringArray[2];
        
        [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"SessionWithToken" substitutionVariables:@{@"TOKEN": sessionToken} completion:^(NSManagedObject *fetchedObject)
        {
            Session *session = (Session *)fetchedObject;
            
            // no session found or the session doesnt belong to our APIAppSession
            if (session.apiAppSession != apiAppSession) {
                
                if (completionBlock) {
                    completionBlock(apiAppSession, nil);
                }
                
                return;
            }
            
            if (completionBlock) {
                completionBlock(apiAppSession, session);
            }
        }];
    }];
}

@end

@implementation SDSServer (PrettyPrintJSON)

-(NSJSONWritingOptions)jsonWritingOption
{
    if (self.prettyPrintJSON) {
        return NSJSONWritingPrettyPrinted;
    }
    
    return 0;
}

@end

@interface SDSServer (Setup)

-(void)setupRoutes;

@end

@implementation SDSServer

- (id)init
{
    self = [super init];
    if (self) {
        
        _server = [[RoutingHTTPServer alloc] init];
        
        // Set a default Server header in the form of YourApp/1.0
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        if (!appVersion) {
            appVersion = [bundleInfo objectForKey:@"CFBundleVersion"];
        }
        NSString *serverHeader = [NSString stringWithFormat:@"%@/%@",
                                  [bundleInfo objectForKey:@"CFBundleName"],
                                  appVersion];
        
        [_server setDefaultHeader:@"Server" value:serverHeader];
        
        // setup REST API
        [self setupRoutes];
        
        // operation Queues
        _createPostQueue = [[NSOperationQueue alloc] init];
        _createPostQueue.maxConcurrentOperationCount = 1; // serialized so the IDs dont get messed up
        
    }
    return self;
}

-(NSError *)startWithPort:(NSUInteger)port
{
    NSAssert(self.dataStore, @"You must set the dataStore property in order for this controller to work");
    
    _server.port = port;
    
    NSError *error;
    [_server start:&error];
    
    if (error) {
        return error;
    }
    
    return nil;
}

@end

@implementation SDSServer (Setup)

-(void)setupRoutes
{
    
#pragma mark - Login API App - GET /login/apiApp
    
#pragma mark - Login User - GET /login/user
    
#pragma mark - Create new user - PUT /user
    
    [_server put:@"/user" withBlock:^(RouteRequest *request, RouteResponse *response) {
        
        // get authentication Data
        [self authenticateUsingRequest:request response:response completion:^(APIAppSession *apiAppSession, Session *session) {
            
            // must create new user through api App
            if (!apiAppSession) {
                
                response.statusCode = UnauthorizedStatusCode;
                
                return;
                
            }
            
            // only first party API clients can create new users
            if (!apiAppSession.apiApp.isNotThirdParty) {
                
                response.statusCode = ForbiddenStatusCode;
                
                return;
            }
            
            // no user should be authenticating
            if (session) {
                
                response.statusCode = BadRequestStatusCode;
                
                return;
            }
            
            // validate Body data...
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:request.body
                                                                       options:NSJSONReadingAllowFragments error:nil];
            
            if (![jsonObject isKindOfClass:[NSDictionary class]]) {
                
                response.statusCode = BadRequestStatusCode;
                return;
            }
            
            // must have required fields
            NSString *username = jsonObject[@"username"];
            NSString *password = jsonObject[@"password"];
            NSString *email = jsonObject[@"email"];
            
            if (!username || !password || !email) {
                
                response.statusCode = BadRequestStatusCode;
                
                return;
            }
            
            // validate username
            BOOL isAlphanumeric = [[username stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet]] isEqualToString:@""];
            
            if (!isAlphanumeric || username.length < 1) {
                
                response.statusCode = BadRequestStatusCode;
                return;
            }
            
            // check if user already exixts
            [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"UserWithUsername" substitutionVariables:@{@"USERNAME": username} completion:^(NSManagedObject *fetchedObject) {
               
                // user already exists
                if (fetchedObject) {
                    
                    response.statusCode = ConflictStatusCode;
                    
                    return;
                }
                
                // create new user
                [self.dataStore createEntityWithName:@"User" completion:^(NSManagedObject *createdEntity)
                 {
                     User *user = (User *)createdEntity;
                     
                     // set initial values
                     user.date = [NSDate date];
                     user.username = username;
                     user.password = password;
                     user.permissions = [NSNumber numberWithInt:DefaultPermissions];
                     
                     // return 200 OK status code
                     response.statusCode = OKStatusCode;
                     
                     return;
                 }];
            }];
        }];
    }];
    
#pragma mark - Get user info - GET /user/:username
    [_server get:@"/user/:username" withBlock:^(RouteRequest *request, RouteResponse *response) {
        
        [self authenticateUsingRequest:request response:response completion:^(APIAppSession *apiAppSession, Session *session) {
           
            if (!apiAppSession) {
                
                response.statusCode = UnauthorizedStatusCode;
                
                return;
            }
            
            NSString *username = request.params[@"username"];
            
            // find requested user
            [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"UserWithUsername" substitutionVariables:@{@"USERNAME": username} completion:^(NSManagedObject *fetchedObject) {
                
                User *user = (User *)fetchedObject;
                
                // user doesn't exist
                if (!user) {
                    
                    response.statusCode = NotFoundStatusCode;
                    
                    return;
                }
                
                
        }];
    }];
        
#pragma mark - Edit User info - POST /user/:username
        
        
    
}

@end