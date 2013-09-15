//
//  Session.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/14/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class APIAppSession, User;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSDate * lastDate;
@property (nonatomic, retain) NSString * lastIP;
@property (nonatomic, retain) NSString * lastUserAgent;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * useragent;
@property (nonatomic, retain) APIAppSession *apiAppSession;
@property (nonatomic, retain) User *user;

@end
