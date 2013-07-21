//
//  Post.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Link, Post, User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *child;
@property (nonatomic, retain) Link *links;
@property (nonatomic, retain) Post *parent;
@property (nonatomic, retain) User *user;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addChildObject:(Post *)value;
- (void)removeChildObject:(Post *)value;
- (void)addChild:(NSSet *)values;
- (void)removeChild:(NSSet *)values;

@end
