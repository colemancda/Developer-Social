//
//  Team.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Team.h"
#import "Image.h"
#import "User.h"


@implementation Team

@dynamic date;
@dynamic id;
@dynamic name;
@dynamic image;
@dynamic members;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
}

@end
