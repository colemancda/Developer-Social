//
//  Skill.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Skill : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * type;

@end
