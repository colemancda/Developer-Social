//
//  Skill+API.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Skill+API.h"
#import "SDSDataModels.h"
#import "NSDate+CDAStringRepresentation.h"

@implementation Skill (API)

-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp
{
    // same permissions as User
    
    return [self.user statusCodeForViewRequestFromUser:user
                                                apiApp:apiApp];
}

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp
{
    // same as user
    return [self.user statusCodeForModifyRequestFromUser:user
                                                  apiApp:apiApp];
}

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject setValue:self.name
                  forKey:@"name"];
    
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    [jsonObject setValue:self.type
                  forKey:@"type"];
    
    if (self.about) {
        
        [jsonObject setValue:self.about
                      forKey:@"about"];
    }
    
    return jsonObject;
}

@end
