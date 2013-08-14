//
//  Session+Authentication.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Session.h"
@class APIApp;

@interface Session (Authentication)

-(void)newRequestWithIP:(NSString *)ipAddress
              userAgent:(NSString *)userAgent
                 apiApp:(APIApp *)apiApp;

@end
