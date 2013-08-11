//
//  User+Custom.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"

typedef NS_ENUM(NSUInteger, UserPermissions) {
    
    DefaultPermissions = 0,
    Moderator = 98,
    Admin = 99
    
};

@interface User (Custom)

-(NSArray *)skillsNames;

-(NSArray *)teamIDs;

@end
