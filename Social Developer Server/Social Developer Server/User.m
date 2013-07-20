//
//  User.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"
#import "Post.h"


@implementation User

@dynamic date;
@dynamic password;
@dynamic username;
@dynamic permissions;
@dynamic location;
@dynamic about;
@dynamic website;
@dynamic posts;
@dynamic teams;
@dynamic image;
@dynamic tokens;
@dynamic accounts;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    
}

@end
