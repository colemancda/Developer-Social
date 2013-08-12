//
//  Skill+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Skill+JSONRepresentation.h"
#import "NSDate+CDAStringRepresentation.h"

@implementation Skill (JSONRepresentation)

#pragma mark - RESTful JSON Representation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // public properties
    
    [jsonObject setValue:self.about
                  forKey:@"about"];
    
    [jsonObject setValue:self.name
                  forKey:@"name"];
    
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    [jsonObject setValue:self.type
                  forKey:@"type"];
    
    return jsonObject;
}

@end
