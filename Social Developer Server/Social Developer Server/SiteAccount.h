//
//  SiteAccount.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface SiteAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * credentials;
@property (nonatomic, retain) User *user;

@end
