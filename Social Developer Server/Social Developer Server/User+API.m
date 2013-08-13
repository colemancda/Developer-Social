//
//  User+API.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User+API.h"
#import "SDSDataModels.h"
#import "APIApp+APIAppUserPermissionsForUser.h"
#import "NSDate+CDAStringRepresentation.h"
#import "NSManagedObject+RelationshipJSONRepresentation.h"

@implementation User (API)

#pragma mark - API

// Tells IF they can see
-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp
{
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // 3rd party access
    if (!apiApp.isNotThirdParty) {
        
        // check if 3rd party API App making the request has permission to view profile
        APIAppUserPermissions *apiAppPermission = [apiApp permissionsForUser:self];
        
        // API App is linked to User's account
        if (apiAppPermission) {
            
            if (apiAppPermission.canViewUserInfo) {
                
                return OKStatusCode;
            }
        }
        
        return ForbiddenStatusCode;
    }
    
    // User profiles are public for 1st party API clients
    return OKStatusCode;
}

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp
{
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // 3rd party access
    if (!apiApp.isNotThirdParty) {
        
        // check if 3rd party API App making the request has permission to edit profile
        APIAppUserPermissions *apiAppPermission = [apiApp permissionsForUser:self];
        
        // API App is linked to User's account
        if (apiAppPermission) {
            
            if (apiAppPermission.canEditUserInfo) {
                
                return OKStatusCode;
            }
        }
        
        return ForbiddenStatusCode;
    }
    
    // User profiles are public for 1st party API clients
    return OKStatusCode;
    
}


// Tells WHAT they can see
-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // date joined
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    // website
    if (self.website) {
        [jsonObject setValue:self.website
                      forKey:@"website"];
    }
    
    // location
    if (self.location) {
        [jsonObject setValue:self.location
                      forKey:@"location"];
    }
    
    // about
    if (self.about) {
        [jsonObject setValue:self.about
                      forKey:@"about"];
    }
    
    // image
    if (self.image) {
        
        // attach ID
        [jsonObject setValue:self.image.id
                      forKey:@"image"];
    }
    
    // skills
    if (self.skills.count) {
        
        NSArray *skillIDs = [self JSONRepresentationForRelationship:@"skills"
                                            usingDestinationProperty:@"id"
                                                             forUser:user
                                                              apiApp:apiApp];
        
        if (skillIDs.count) {
            
            [jsonObject setObject:skillIDs
                           forKey:@"skills"];
            
        }
    }
    
    // teams
    if (self.teams.count) {
        
        NSArray *teamIDs = [self JSONRepresentationForRelationship:@"teams"
                                          usingDestinationProperty:@"id"
                                                           forUser:user
                                                            apiApp:apiApp];
        
        if (teamIDs.count) {
            
            [jsonObject setValue:teamIDs
                          forKey:@"teams"];
        }
    }
    
    // other site accounts
    if (self.accounts.count) {
        
        NSArray *accountIDs = [self JSONRepresentationForRelationship:@"accounts"
                                          usingDestinationProperty:@"id"
                                                           forUser:user
                                                            apiApp:apiApp];
        if (accountIDs.count) {
            [jsonObject setValue:accountIDs
                          forKey:@"accounts"];
        }
    }
    
    // followers
    if (self.followers.count) {
        
        NSArray *followersUsernames = [self JSONRepresentationForRelationship:@"followers"
                                                     usingDestinationProperty:@"username"
                                                                      forUser:user
                                                                       apiApp:apiApp];
        if (followersUsernames.count) {
            [jsonObject setValue:followersUsernames
                          forKey:@"followers"];
        }
    }
    
    // following
    if (self.following.count) {
        
        NSArray *followingUsernames = [self JSONRepresentationForRelationship:@"following"
                                                     usingDestinationProperty:@"username"
                                                                      forUser:user
                                                                       apiApp:apiApp];
        if (followingUsernames.count) {
            [jsonObject setValue:followingUsernames
                          forKey:@"following"];
        }
    }
    
    // posts
    if (self.posts.count) {
        
        NSArray *postsIDs = [self JSONRepresentationForRelationship:@"posts"
                                           usingDestinationProperty:@"id"
                                                            forUser:user
                                                             apiApp:apiApp];
        if (postsIDs.count) {
            [jsonObject setValue:postsIDs
                          forKey:@"posts"];
        }
    }
    
    // admin of teams
    if (self.adminOfTeams.count) {
        
        NSArray *adminOfTeams = [self JSONRepresentationForRelationship:@"adminOfTeams"
                                               usingDestinationProperty:@"id"
                                                                forUser:user
                                                                 apiApp:apiApp];
        
        if (adminOfTeams.count) {
            
            [jsonObject setValue:adminOfTeams
                          forKey:@"adminOfTeams"];
        }
    }
    
    // Private properties (can only be seen by first party clients)
    if (user == self &&
        apiApp.isNotThirdParty) {
        
        // password
        [jsonObject setValue:self.password
                      forKey:@"password"];
        
        // permissions level
        [jsonObject setValue:self.permissions
                      forKey:@"permissions"];
        
    }
    
    return jsonObject;
}


@end
