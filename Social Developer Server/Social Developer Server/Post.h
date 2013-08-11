//
//  Post.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Link, Post, User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *child;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) Post *parent;
@property (nonatomic, retain) User *user;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addChildObject:(Post *)value;
- (void)removeChildObject:(Post *)value;
- (void)addChild:(NSSet *)values;
- (void)removeChild:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addLinksObject:(Link *)value;
- (void)removeLinksObject:(Link *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

@end
