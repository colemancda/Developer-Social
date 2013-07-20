//
//  Image.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team, User;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Team *team;

@end
