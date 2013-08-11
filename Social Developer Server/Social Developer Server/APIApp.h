//
//  APIApp.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class APIAppUserPermissions;

@interface APIApp : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *usersPermissions;
@end

@interface APIApp (CoreDataGeneratedAccessors)

- (void)addUsersPermissionsObject:(APIAppUserPermissions *)value;
- (void)removeUsersPermissionsObject:(APIAppUserPermissions *)value;
- (void)addUsersPermissions:(NSSet *)values;
- (void)removeUsersPermissions:(NSSet *)values;

@end
