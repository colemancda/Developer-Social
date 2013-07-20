//
//  Token.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Token : NSManagedObject

@property (nonatomic, retain) NSString * stringValue;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSManagedObject *client;

@end
