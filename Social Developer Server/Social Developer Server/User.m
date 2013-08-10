//
//  User.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/23/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"
#import "Image.h"
#import "Post.h"
#import "Session.h"
#import "SiteAccount.h"
#import "Team.h"
#import "User.h"


@implementation User

@dynamic about;
@dynamic date;
@dynamic location;
@dynamic password;
@dynamic permissions;
@dynamic username;
@dynamic website;
@dynamic accounts;
@dynamic followers;
@dynamic following;
@dynamic image;
@dynamic posts;
@dynamic sessions;
@dynamic teams;

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // set date
    self.date = [NSDate date];
    
    // default permissions level
    self.permissions = [NSNumber numberWithInteger:DefaultPermissions];
    
}

@end
