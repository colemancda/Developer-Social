//
//  Session.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSDate * lastUse;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * useragent;
@property (nonatomic, retain) User *user;

@end
