//
//  APIApp.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class APIAppSession, APIAppUserPermissions;

@interface APIApp : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isNotThirdParty;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * secret;
@property (nonatomic, retain) NSSet *usersPermissions;
@property (nonatomic, retain) NSSet *apiAppSessions;
@end

@interface APIApp (CoreDataGeneratedAccessors)

- (void)addUsersPermissionsObject:(APIAppUserPermissions *)value;
- (void)removeUsersPermissionsObject:(APIAppUserPermissions *)value;
- (void)addUsersPermissions:(NSSet *)values;
- (void)removeUsersPermissions:(NSSet *)values;

- (void)addApiAppSessionsObject:(APIAppSession *)value;
- (void)removeApiAppSessionsObject:(APIAppSession *)value;
- (void)addApiAppSessions:(NSSet *)values;
- (void)removeApiAppSessions:(NSSet *)values;

@end
