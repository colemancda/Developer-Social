//
//  APIApp.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/10/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface APIApp : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *usersPermissions;

@end
