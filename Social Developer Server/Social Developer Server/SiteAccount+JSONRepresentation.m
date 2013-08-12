//
//  SiteAccount+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SiteAccount+JSONRepresentation.h"
#import "SDSDataModels.h"

@implementation SiteAccount (JSONRepresentation) 

#pragma mark - RESTful JSON Repressentation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setValue:self.username
                  forKey:@"username"];
    
    [jsonObject setValue:self.type
                  forKey:@"type"];
    
    // these properties are visible if the siteAccount is requested by the user that owns it or an Admin
    if (user == self.user ||
        user.permissions.integerValue == Admin) {
        
        
        
    }
    
    return jsonObject;
}

@end
