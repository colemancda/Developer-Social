//
//  APIApp+APIAppUserPermissionsForUser.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "APIApp+APIAppUserPermissionsForUser.h"
#import "SDSDataModels.h"

@implementation APIApp (APIAppUserPermissionsForUser)

-(APIAppUserPermissions *)permissionsForUser:(User *)user
{
    // find user in graph
    for (APIAppUserPermissions *apiAppUserPermission in self.usersPermissions) {
        
        if (apiAppUserPermission.user == user) {
            
            return apiAppUserPermission;
        }
    }
    
    return nil;
}

@end
