//
//  SDSJSON.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, APIApp;

#define AssertUserForRESTfulJSONRepresentation NSAssert(user, @"Must provide User to generate JSON representation");

#define AssertAPIAppForRESTfulJSONRepresentation NSAssert(apiApp, @"Must provide API App to generate JSON representation");

@protocol SDSJSON <NSObject>

// JSON representation for the user and api making the request
-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp;

@end
