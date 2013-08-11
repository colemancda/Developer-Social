//
//  User+Custom.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User+Custom.h"
#import "Skill.h"

@implementation User (Custom)

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
    
    // default permissions level
    self.permissions = [NSNumber numberWithInteger:DefaultPermissions];
}

#pragma mark

-(NSArray *)skillsNames
{
    // get the IDs of our skills...
    
    NSMutableArray *skillsNames = [[NSMutableArray alloc] init];
    
    for (Skill *skill in self.skills) {
        
        [skillsNames addObject:skill.name];
        
    }
    
    return skillsNames;
}

-(NSArray *)teamIDs
{
    // get the IDs of the teams the user is a member of...
    
    
}

@end
