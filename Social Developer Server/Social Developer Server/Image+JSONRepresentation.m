//
//  Image+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Image+JSONRepresentation.h"
#import "Image+Visibility.h"
#import "NSDate+CDAStringRepresentation.h"

@implementation Image (JSONRepresentation)

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    if (![self isVisibleToUser:user
                        apiApp:apiApp]) {
        return nil;
    }
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // name
    if (self.name) {
        [jsonObject setValue:self.name
                      forKey:@"name"];
    }
    
    // about
    if (self.about) {
        [jsonObject setValue:self.about
                      forKey:@"about"];
    }
    
    // date
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    // fileName
    [jsonObject setValue:self.filename
                  forKey:@"filename"];
    
    
    return jsonObject;
}

@end
