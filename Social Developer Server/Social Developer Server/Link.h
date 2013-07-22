//
//  Link.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/22/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Link : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Post *post;

@end
