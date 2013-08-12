//
//  User+Visibility.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User+Visibility.h"
#import "SDSDataModels.h"
#import "APIApp+APIAppUserPermissionsForUser.h"

@implementation User (Visibility)

-(BOOL)isVisibleToUser:(User *)user
                apiApp:(APIApp *)apiApp
{
    // third party app making request
    if (!apiApp.isNotThirdParty) {
        
        // check if 3rd party API App making the request has permission
        APIAppUserPermissions *apiAppPermission = [apiApp permissionsForUser:self];
        
        // 3rd party API App hasnt been given any permissions
        if (!apiAppPermission) {
            return NO;
        }
        
        // User has not authorized this API App to view his own profile
        if (apiAppPermission && !apiAppPermission.canViewUserInfo) {
            return NO;
        }
    }
    
    // 1st party API apps, or 3rd party with proper permissions, can view this user's info
    return YES;
}

@end
