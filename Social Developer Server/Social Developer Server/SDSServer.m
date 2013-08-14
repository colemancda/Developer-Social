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

#define REQUIRE_APIAPP(apiApp, response) if (!apiApp) response.statusCode = UnauthorizedStatusCode; return;

@implementation SDSServer (Authentication)

-(void)authenticateUserForRequest:(RouteRequest *)request

-(void)authenticateUsingRequest:(RouteRequest *)request
                       response:(RouteResponse *)response
                     completion:(void (^)(APIApp *apiApp, User *user))completionBlock
{
    // get the authentication from HTTP header
    
    NSString *authorizationString = request.headers[@"Authorization"];
    
    // authorization header is "SDS <apiAppSecret> <userToken>"
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
    
    // get API app secrect
    NSString *apiAppSecret = parsedAuthStringArray[1];
    
    [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"APIAppWithSecret" substitutionVariables:@{@"SECRET": apiAppSecret} completion:^(NSManagedObject *fetchedObject)
    {
        APIApp *apiApp = (APIApp *)fetchedObject;
        
        
        
    }];
    
    // find token in DB
    
    [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"SessionWithToken" substitutionVariables:@{@"TOKEN": token} completion:^(NSManagedObject *fetchedObject) {
        
        // get session
        Session *session = (Session *)fetchedObject;
        
        // No authentication
        if (!session) {
            
            if (completionBlock) {
                completionBlock(nil);
            }
        }
        
        // find API App
        NSString *apiAppSecret = nil;
        
        if (parsedAuthStringArray.count == 3) {
            
            apiAppSecret = parsedAuthStringArray[2];
        }
        
        
           
            APIApp *apiApp = (APIApp *)fetchedObject;
            
            // add this request to the Session
            [session newRequestWithIP:response.ipAddress
                            userAgent:request.headers[@"User-Agent"]
                               apiApp:apiApp];
            
            if (completionBlock) {
                completionBlock(session);
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

-(NSError *)startWithPort:(NSUInteger)port
{
    NSAssert(self.dataStore, @"You must set the dataStore property in order for this controller to work");
    
    _server = [[RoutingHTTPServer alloc] init];
    _server.port = port;
    
    NSError *error;
    [_server start:&error];
    
    if (error) {
        return error;
    }
    
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
    
    [self setupRoutes];
    
    return nil;
}

@end

@implementation SDSServer (Setup)

-(void)setupRoutes
{
    
#pragma mark - PUT /user
    
    [_server put:@"/user" withBlock:^(RouteRequest *request, RouteResponse *response) {
        
        // get authentication Data
        [self authenticateUsingRequest:request response:response completion:^(APIApp *apiApp, User *user) {
            
            REQUIRE_APIAPP(apiApp, response);
            
            // only first party API clients can create new users
            if (!session.apiApp.isNotThirdParty) {
                
                response.statusCode = ForbiddenStatusCode;
                
                return;
            }
            
        }];
        
        // validate Body data...
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:request.body
                                                                   options:NSJSONReadingAllowFragments error:nil];
        
        if (![jsonObject isKindOfClass:[NSDictionary class]]) {
            
            response.statusCode = BadRequestStatusCode;
            return;
        }
        
        // must have required fields
        
        
    }];
    
#pragma mark - GET /user/:username
    [_server get:@"/user/:username" withBlock:^(RouteRequest *request, RouteResponse *response) {
        
        [self authenticateUsingRequest:request response:response completion:^(APIApp *apiApp, User *user) {
            
            REQUIRE_APIAPP(apiApp, user);
            
            
            
            
        }];
        
        NSString *username = request.params[@"username"];
        
        [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"UserWithUsername" substitutionVariables:@{@"USERNAME": username} completion:^(NSManagedObject *fetchedObject) {
            
            // user doesn't exist
            if (!fetchedObject) {
                
                response.statusCode = NotFoundStatusCode;
                
                return;
            }
            
            // user the request wants
            User *user = (User *)fetchedObject;
            
            // get user making the request
            [self authenticateUsingRequest:request response:response completion:^(Session *session)
             {
                 HTTPStatusCode statusCode = [user statusCodeForViewRequestFromUser:session.user
                                                                             apiApp:session.apiApp];
                 
                 // error
                 if (statusCode != OKStatusCode) {
                     
                     response.statusCode = statusCode;
                     
                     return;
                 }
                 
                 NSDictionary *jsonObject = [user JSONRepresentationForUser:session.user
                                                                     apiApp:session.apiApp];
                                  
                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                                    options:self.jsonWritingOption
                                                                      error:nil];
                 
                 [response respondWithData:jsonData];
                 
             }];
        }];
    }];
    

    
}

@end