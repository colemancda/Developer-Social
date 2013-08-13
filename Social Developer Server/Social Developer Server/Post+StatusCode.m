//
//  Post+StatusCode.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post+StatusCode.h"
#import "SDSDataModels.h"

@implementation Post (StatusCode)

-(HTTPStatusCode)statusCodeForRequestFromUser:(User *)user
                                        apiApp:(APIApp *)apiApp
{
    // dont need Api app to view post
    return [self statusCodeForRequestFromUser:user];
}

-(HTTPStatusCode)statusCodeForRequestFromUser:(User *)user
{
    // check for parent visibility
    if (self.parent) {
        return [self.parent statusCodeForRequestFromUser:user];
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
    
    return ForbiddenStatusCode;
}

@end
