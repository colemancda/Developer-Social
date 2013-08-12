//
//  SiteAccount+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SiteAccount+JSONRepresentation.h"

@implementation SiteAccount (JSONRepresentation) 

#pragma mark - RESTful JSON Repressentation Protocol

-(NSDictionary *)publicInfo
{
    NSMutableDictionary *publicInfo = [[NSMutableDictionary alloc] init];
    
    [publicInfo setValue:self.username
                  forKey:@"username"];
    
    [publicInfo setValue:self.type
                  forKey:@"type"];
    
    return publicInfo;
}

-(NSDictionary *)allInfo
{
    NSMutableDictionary *allInfo = [[NSMutableDictionary alloc] initWithDictionary:self.publicInfo];
    
    // add sensitive info
    
    
    return allInfo;
}

@end
