//
//  Team.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/14/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Post, User;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * open;
@property (nonatomic, retain) User *admin;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) NSSet *visiblePosts;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMembersObject:(User *)value;
- (void)removeMembersObject:(User *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

- (void)addVisiblePostsObject:(Post *)value;
- (void)removeVisiblePostsObject:(Post *)value;
- (void)addVisiblePosts:(NSSet *)values;
- (void)removeVisiblePosts:(NSSet *)values;

@end
