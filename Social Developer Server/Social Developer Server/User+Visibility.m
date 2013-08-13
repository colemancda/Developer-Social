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
    // we ignore which user is requesting, we only care which API App is
    
    // an API App must make this request
    if (apiApp) {
        
        // third party app
        if (!apiApp.isNotThirdParty) {
            
            // check if 3rd party API App making the request has permission to view profile
            APIAppUserPermissions *apiAppPermission = [apiApp permissionsForUser:self];
            
            // API App is linked to User's account
            if (apiAppPermission) {
                
                return apiAppPermission.canViewUserInfo.boolValue;
            }
            
            // User is not associated with API App
            else {
                
                return NO;
            }
        }
        
        // first party app
        else {
            
            return YES;
            
        }
    }
    
    // no API App made the request
    return NO;
}

@end
