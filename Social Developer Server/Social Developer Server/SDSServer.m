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

#import "SDSDataModels.h"

@implementation SDSServer (Authentication)

-(void)authenticationForRequest:(RouteRequest *)request
                     completion:(void (^)(User *user, APIApp *apiApp))completionBlock
{
    // get the authentication from HTTP header
    
    NSString *authorizationString = request.headers[@"Authorization"];
    
    NSArray *parsedAuthStringArray = [authorizationString componentsSeparatedByString:@" "];
    
    // no token
    if (!parsedAuthStringArray ||
        (parsedAuthStringArray.count == 2 ||
         parsedAuthStringArray.count == 3)||
        ![parsedAuthStringArray[0] isEqualToString:@"SDS"]) {
        
        completionBlock(nil, nil);
        return;
    }
    
    // get token
    NSString *token = parsedAuthStringArray[1];
    
    // find token in DB
    
    [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"SessionWithToken" substitutionVariables:@{@"TOKEN": token} completion:^(NSManagedObject *fetchedObject) {
        
        Session *session = (Session *)fetchedObject;
        
        if (parsedAuthStringArray.count != 3) {
            completionBlock(session.user, nil);
            
        }
        
        // find API App
        else {
            
            NSString *apiAppSecret = parsedAuthStringArray[2];
            
            [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"APIAppWithSecret" substitutionVariables:@{@"SECRET": apiAppSecret} completion:^(NSManagedObject *fetchedObject) {
                
                completionBlock(session.user, (APIApp *)fetchedObject);
            }];
        }
    }];
}

@end

@implementation SDSServer

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

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

-(void)setupRoutes
{
    // Get user info
    [_server get:@"/user/:username" withBlock:^(RouteRequest *request, RouteResponse *response) {
        
        NSString *username = request.params[@"username"];
        
        [self.dataStore executeSingleResultFetchRequestTemplateWithName:@"UserWithUsername" substitutionVariables:@{@"USERNAME": username} completion:^(NSManagedObject *fetchedObject) {
           
            // doesnt exist
            if (!fetchedObject) {
                
                response.statusCode = BadRequestStatusCode;
                
                return;
            }
            
            // user the request wants
            User *user = (User *)fetchedObject;
            
            // get user making the request
            [self authenticationForRequest:request completion:^(User *authenticatingUser, APIApp *apiApp) {
                
                NSDictionary *jsonObject = [user JSONRepresentationForUser:authenticatingUser
                                                                    apiApp:apiApp];
                
                // dont have permission to see this
                if (!jsonObject) {
                    
                    
                    
                }
                
                
            }];
        }];
    }];
}

@end