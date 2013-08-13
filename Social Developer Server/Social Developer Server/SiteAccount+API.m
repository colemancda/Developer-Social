//
//  SiteAccount+API.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SiteAccount+API.h"
#import "SDSDataModels.h"

@implementation SiteAccount (API)

-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp
{
    // same as user permissions
    return [self.user statusCodeForViewRequestFromUser:user
                                                apiApp:apiApp];
}

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp
{
    return [self.user statusCodeForModifyRequestFromUser:user
                                                  apiApp:apiApp];
}

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    [jsonObject addEntriesFromDictionary:@{@"username": self.username, @"type" : self.type}];
    
    if (user == self.user &&
        apiApp.isNotThirdParty) {
        
        [jsonObject setValue:self.credentials
                      forKey:@"credentials"];
    }
    
    return jsonObject;
}

@end
