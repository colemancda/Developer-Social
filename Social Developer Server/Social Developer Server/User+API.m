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
        
        NSMutableArray *skills = [[NSMutableArray alloc] init];
        
        for (Skill *skill in self.skills) {
            
            NSDictionary *jsonObject = @{@"name": skill.name,
                                         @"date": skill.date.stringValue,
                                         @"about": skill.about,
                                         @"type": skill.type};
            
        }
        
        if (skills.count) {
            
            [jsonObject setObject:skills
                           forKey:@"skills"]
            
        }
    }
    
    // teams
    if (self.teams.count) {
        
        NSArray *teamIDs = 
        
        // get team IDs
        [jsonObject setValue:self.teamIDs
                      forKey:@"teams"];
    }
    
    // other site accounts
    if (self.accounts.count) {
        
        // get public account info
        NSMutableArray *accountsInfo = [[NSMutableArray alloc] init];
        
        for (SiteAccount *siteAccount in self.accounts) {
            
            // 'SiteAccount' ignores who is making the request
            [accountsInfo addObject:[siteAccount JSONRepresentationForUser:user
                                                                    apiApp:apiApp]];
        }
        
        [jsonObject setValue:accountsInfo
                      forKey:@"accounts"];
    }
    
    // followers
    if (self.followers.count) {
        
        [jsonObject setValue:self.followersUsernames
                      forKey:@"followers"];
    }
    
    // following
    if (self.following.count) {
        
        [jsonObject setValue:self.followingUsernames
                      forKey:@"following"];
    }
    
    // posts
    if (self.posts.count) {
        
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        
        for (Post *post in self.posts) {
            
            // only add Posts' IDs that are visible for the user and API App making the request
            if ([post isVisibleToUser:user
                               apiApp:apiApp]) {
                
                [posts addObject:post.id];
            }
        }
        
        // add to jsonObject if at least 1 post is visible
        if (posts.count) {
            [jsonObject setValue:posts
                          forKey:@"posts"];
        }
    }
    
    // Private properties
    if (user == self) {
        
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
