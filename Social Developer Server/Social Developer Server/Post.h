//
//  Post.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/14/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Link, Post, Team, User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) Post *parent;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *visibleToTeams;
@property (nonatomic, retain) NSSet *visibleToUsers;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Post *)value;
- (void)removeChildrenObject:(Post *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addLinksObject:(Link *)value;
- (void)removeLinksObject:(Link *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

- (void)addVisibleToTeamsObject:(Team *)value;
- (void)removeVisibleToTeamsObject:(Team *)value;
- (void)addVisibleToTeams:(NSSet *)values;
- (void)removeVisibleToTeams:(NSSet *)values;

- (void)addVisibleToUsersObject:(User *)value;
- (void)removeVisibleToUsersObject:(User *)value;
- (void)addVisibleToUsers:(NSSet *)values;
- (void)removeVisibleToUsers:(NSSet *)values;

@end
