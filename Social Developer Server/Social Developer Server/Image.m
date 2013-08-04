//
//  Image.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Image.h"
#import "Team.h"
#import "User.h"


@implementation Image

@dynamic data;
@dynamic date;
@dynamic filename;
@dynamic id;
@dynamic team;
@dynamic user;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
}


@end
