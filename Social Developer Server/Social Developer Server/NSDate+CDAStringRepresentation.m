//
//  NSDate+CDAStringRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "NSDate+CDAStringRepresentation.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (CDAStringRepresentation)

-(NSString *)stringValue
{
    if (!dateFormatter) {
        
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-DD HH:MM:SS ±HHMM";
    }
    
    return [dateFormatter stringFromDate:self];
}

@end
