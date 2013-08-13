//
//  Post+API.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post+API.h"
#import "SDSDataModels.h"
#import "NSDate+CDAStringRepresentation.h"
#import "NSManagedObject+RelationshipJSONRepresentation.h"
#import "APIApp+APIAppUserPermissionsForUser.h"

@implementation Post (API)

-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp
{
    // need API App to view post
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // check for parent visibility
    if (self.parent) {
        return [self.parent statusCodeForViewRequestFromUser:user
                                                      apiApp:apiApp];
    }
    
    // check if post has special permissions
    if (!self.visibleToTeams.count &&
        !self.visibleToUsers.count)
    {
        // post is public
        return OKStatusCode;
    }
    
    // check if user is allowed to see it
    for (User *allowedUser in self.visibleToUsers) {
        
        if (allowedUser == user) {
            return OKStatusCode;
        }
    }
    
    // check if user belongs to team that is allowed to see post
    for (Team *team in self.visibleToTeams) {
        
        for (User *member in team.members) {
            
            if (member == user) {
                return OKStatusCode;
            }
        }
    }
    
    // creator can always see it
    if (user == self.user) {
        return OKStatusCode;
    }
    
    return ForbiddenStatusCode;

}

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp
{
    // need API App to edit post
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // users can only edit their own posts
    if (user != self.user) {
        return ForbiddenStatusCode;
    }
    
    // 3rd party api apps must have permission
    if (!apiApp.isNotThirdParty) {
        
        APIAppUserPermissions *apiAppUserPermissions = [apiApp permissionsForUser:self.user];
        
        // API App is not linked to account
        if (!apiAppUserPermissions) {
            return ForbiddenStatusCode;
        }
        
        // User has not granted third party app permission to post
        if (!apiAppUserPermissions.canPost) {
            return ForbiddenStatusCode;
        }
    }
    
    return OKStatusCode;
}

-(NSDictionary *)JSONRepresentationForUser:(User *)user apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // Post properties
    
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    [jsonObject setValue:self.text
                  forKey:@"text"];
    
    // Post Relationships
    
    // creator
    [jsonObject setValue:self.user.username
                  forKey:@"user"];
    
    // parent post
    if (self.parent) {
        [jsonObject setValue:self.parent.id
                      forKey:@"parent"];
    }
    
    // children posts
    if (self.children.count) {
        
        NSArray *childrenIDs = [self JSONRepresentationForRelationship:@"children"
                                              usingDestinationProperty:@"id"
                                                               forUser:user
                                                                apiApp:apiApp];
        if (childrenIDs.count) {
            
            [jsonObject setValue:childrenIDs
                          forKey:@"children"];
        }
    }
    
    // images
    if (self.images.count) {
        
        NSArray *imagesIDs = [self JSONRepresentationForRelationship:@"images"
                                            usingDestinationProperty:@"id"
                                                             forUser:user
                                                              apiApp:apiApp];
        if (imagesIDs.count) {
            [jsonObject setValue:imagesIDs
                          forKey:@"images"];
        }
    }
    
    // links
    if (self.links.count) {
        
        NSArray *linksIDs = [self JSONRepresentationForRelationship:@"links"
                                           usingDestinationProperty:@"id"
                                                            forUser:user
                                                             apiApp:apiApp];
        
        if (linksIDs.count) {
            [jsonObject setValue:linksIDs
                          forKey:@"links"];
        }
    }
    
    return jsonObject;
}

@end
