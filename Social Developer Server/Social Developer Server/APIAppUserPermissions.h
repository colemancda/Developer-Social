//
//  APIAppUserPermissions.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class APIApp, User;

@interface APIAppUserPermissions : NSManagedObject

@property (nonatomic, retain) NSNumber * canEditUserInfo;
@property (nonatomic, retain) NSNumber * canPost;
@property (nonatomic, retain) NSNumber * canViewUserInfo;
@property (nonatomic, retain) APIApp *apiApp;
@property (nonatomic, retain) User *user;

@end
