//
//  SDSStatusCode.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPStatusCodes.h"
@class User, APIApp;

@protocol SDSStatusCode <NSObject>

-(HTTPStatusCodes)statusCodeForRequestFromUser:(User *)user
                                        apiApp:(APIApp *)apiApp;

@end
