//
//  Post+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post+JSONRepresentation.h"
#import "SDSDataModels.h"

@implementation Post (JSONRepresentation)

#pragma mark - RESTful JSON Representation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    AssertUserForRESTfulJSONRepresentation
    AssertAPIAppForRESTfulJSONRepresentation
    
    // check for 3rd party API App
    if (!apiApp.isNotThirdParty) {
        
        // check if 3rd party API App making the request has permission
        APIAppUserPermissions *apiAppPermission = [apiApp permissionsForUser:user];
        
        // User has not authorized this API App to view his own profile
        if (!apiAppPermission.canViewUserInfo) {
            return nil;
        }
    }
    
}

@end
