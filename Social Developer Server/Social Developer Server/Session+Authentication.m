//
//  Session+Authentication.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Session+Authentication.h"

@implementation Session (Authentication)

-(void)newRequestWithIP:(NSString *)ipAddress
              userAgent:(NSString *)userAgent
                 apiApp:(APIApp *)apiApp
{
    // update last used date
    self.lastUse = [NSDate date];
    
    if (apiApp) {
        self.apiApp = apiApp;
    }
    
    if (userAgent) {
        self.useragent = userAgent;
    }
    
    self.ip = ipAddress;
}

@end
