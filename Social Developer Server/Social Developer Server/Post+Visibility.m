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
    
    // 1st party requests
    if (apiApp.isNotThirdParty) {
        
        // as long as the user can view this, then 
        
    }
    
    // Only 3rd party apps with proper permissions can view this
    else {
        
        
        
    }
    
    return NO;
}

-(BOOL)isVisibleToUser:(User *)user
{
    
    
}

@end
