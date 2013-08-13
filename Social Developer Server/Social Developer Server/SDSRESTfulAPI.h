//
//  SDSRESTfulAPI.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPStatusCodes.h"
@class User, APIApp;

@protocol SDSRESTfulAPI <NSObject>

-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp;

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp;

// JSON representation for the user and api making the GET request
-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp;

@end
