//
//  SiteAccount+Custom.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SiteAccount+Custom.h"

@implementation SiteAccount (Custom)

-(NSDictionary *)publicInfo
{
    return @{@"username": self.username,
             @"type" : self.type};
}

@end
