//
//  SDSJSON.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, APIApp;

@protocol SDSJSON <NSObject>

// JSON representation for the user and api making the request
-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp;

@end
