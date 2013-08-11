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

#import "SDSDataModels.h"

@implementation CDASQLiteDataStore (UserAuthentication)

// get the User who is making the request
-(void)authenticatedUserForRequest:(RouteRequest *)request
                        completion:(void (^)(User *user))completionBlock
{
    // get the authentication from HTTP header
    
    NSString *authorizationString = request.headers[@"Authorization"];
    
    NSArray *parsedAuthStringArray = [authorizationString componentsSeparatedByString:@" "];
    
    // no token
    if (!parsedAuthStringArray ||
        parsedAuthStringArray.count != 2 ||
        ![parsedAuthStringArray[0] isEqualToString:@"SDSToken"]) {
        
        completionBlock(nil);
        return;
    }
    
    // get token
    NSString *token = parsedAuthStringArray[1];
    
    // find match in DB
    
    [self executeSingleResultFetchRequestTemplateWithName:@"SessionWithToken" substitutionVariables:@{@"TOKEN": token} completion:^(NSManagedObject *fetchedObject) {
        
        Session *session = (Session *)fetchedObject;
        
        // no session matched that token
        if (!session) {
            
            completionBlock(nil);
            return;
        }
        
        completionBlock(session.user);
        return;
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
           
            if (!fetchedObject) {
                
                response.statusCode = 404;
                
                return;
            }
            
            // user the request wants
            User *user = (User *)fetchedObject;
            
            // get user making the request
            [self.dataStore authenticatedUserForRequest:request completion:^(User *authenticatingUser) {
                
                // get public properties
                NSMutableDictionary *userJsonObject = [[NSMutableDictionary alloc] init];
                
                // date joined
                [userJsonObject setValue:user.date
                                  forKey:@"date"];
                
                // website
                if (user.website) {
                    [userJsonObject setValue:user.website
                                      forKey:@"website"];
                }
                
                // location
                if (user.location) {
                    [userJsonObject setValue:user.location
                                      forKey:@"location"];
                }
                
                // about
                if (user.about) {
                    [userJsonObject setValue:user.about
                                      forKey:@"about"];
                }
                
                // image
                if (user.image) {
                    
                    // attach ID
                    [userJsonObject setValue:user.image.id
                                      forKey:@"image"];
                }
                
                // skills
                if (user.skills.count) {
                    
                    // get the name for each skill
                    [userJsonObject setValue:user.skillsNames
                                      forKey:@"skills"];
                }
                
                // teams
                if (user.teams.count) {
                    
                    
                    
                }
               
                // no user is authenticated
                if (!authenticatingUser) {
                    
                    
                    
                }
                
                
                
            }];
        }];
    }];
}

@end
