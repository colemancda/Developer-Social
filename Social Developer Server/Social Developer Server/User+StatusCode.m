//
//  User+StatusCode.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User+StatusCode.h"
#import "SDSDataModels.h"

@implementation User (StatusCode)

-(HTTPStatusCodes)statusCodeForRequestFromUser:(User *)user
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

@end
