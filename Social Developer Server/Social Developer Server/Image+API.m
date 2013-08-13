//
//  Image+API.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Image+API.h"
#import "NSDate+CDAStringRepresentation.h"
#import "SDSDataModels.h"

@implementation Image (API)

-(HTTPStatusCode)statusCodeForViewRequestFromUser:(User *)user
                                           apiApp:(APIApp *)apiApp
{
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // check what this image belongs to...
    
    // user image
    if (self.user) {
        return OKStatusCode;
    }
    
    // team image
    if (self.team) {
        return OKStatusCode;
    }
    
    // post image
    if (self.post) {
        
        // check if post is visible
        return [self.post statusCodeForViewRequestFromUser:user
                                                    apiApp:apiApp];
    }
    
    return ForbiddenStatusCode;
}

-(HTTPStatusCode)statusCodeForModifyRequestFromUser:(User *)user
                                             apiApp:(APIApp *)apiApp
{
    if (!apiApp) {
        return UnauthorizedStatusCode;
    }
    
    // check what this image belongs to...
    
    // user image
    if (self.user) {
        
        if (self.user == user) {
            return OKStatusCode;
        }
    }
    
    // team image
    if (self.team) {
        
        // has to be team admin
        if (self.team.admin == user) {
            return OKStatusCode;
        }
    }
    
    // post image
    if (self.post) {
        
        // check if user can edit post
        return [self.post statusCodeForModifyRequestFromUser:user
                                                      apiApp:apiApp];
    }
    
    return ForbiddenStatusCode;
}

-(NSDictionary *)JSONRepresentationForUser:(User *)user apiApp:(APIApp *)apiApp
{
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
