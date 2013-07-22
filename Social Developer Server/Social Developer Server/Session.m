//
//  Session.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Session.h"
#import "User.h"

@implementation Session

@dynamic date;
@dynamic ip;
@dynamic lastUse;
@dynamic token;
@dynamic useragent;
@dynamic user;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
}

@end
