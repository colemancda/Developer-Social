//
//  Post+Visibility.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post+Visibility.h"
#import "SDSDataModels.h"
#import "APIApp+APIAppUserPermissionsForUser.h"

@implementation Post (Visibility)

-(BOOL)isVisibleToUser:(User *)user
                apiApp:(APIApp *)apiApp
{
    // Must request through API App
    if (!apiApp) {
        return NO;
    }
    
    return [self isVisibleToUser:user];
}

-(BOOL)isVisibleToUser:(User *)user
{
    // check for parent visibility
    if (self.parent) {
        return [self.parent isVisibleToUser:user];
    }
    
    // check if post has special permissions
    if (!self.visibleToTeams.count &&
        !self.visibleToUsers.count)
    {
        // post is public
        return YES;
    }
    
    // check if user is allowed to see it
    for (User *allowedUser in self.visibleToUsers) {
        
        if (allowedUser == user) {
            return YES;
        }
    }
    
    // check if user belongs to team that is allowed to see post
    for (Team *team in self.visibleToTeams) {
        
        for (User *member in team.members) {
            
            if (member == user) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
