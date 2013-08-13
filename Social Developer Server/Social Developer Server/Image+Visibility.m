//
//  Image+Visibility.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Image+Visibility.h"
#import "Post+Visibility.h"

@implementation Image (Visibility)

-(BOOL)isVisibleToUser:(User *)user
                apiApp:(APIApp *)apiApp
{
    if (apiApp) {
        
        // check what this image belongs to...
        
        // user image
        if (self.user) {
            return YES;
        }
        
        // team image
        if (self.team) {
            return YES;
        }
        
        // post image
        if (self.post) {
            
            // check if post is visible
            return [self.post isVisibleToUser:user
                                       apiApp:apiApp];
        }
    }
    
    return NO;
}

@end
