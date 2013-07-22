//
//  Link.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/22/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Link.h"
#import "Post.h"


@implementation Link

@dynamic id;
@dynamic type;
@dynamic url;
@dynamic date;
@dynamic post;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
}

@end
