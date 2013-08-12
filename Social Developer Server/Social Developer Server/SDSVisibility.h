//
//  SDSVisibility.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, APIApp;

@protocol SDSVisibility <NSObject>

-(BOOL)isVisibleToUser:(User *)user
                apiApp:(APIApp *)apiApp;

@end
