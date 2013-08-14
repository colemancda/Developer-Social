//
//  Image.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post, Team, User;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) User *user;

@end
