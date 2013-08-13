//
//  Post+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post+JSONRepresentation.h"
#import "SDSDataModels.h"
#import "APIApp+APIAppUserPermissionsForUser.h"
#import "Post+JSONRepresentation.h"
#import "NSDate+CDAStringRepresentation.h"
#import "NSManagedObject+RelationshipJSONRepresentation.h"

@implementation Post (JSONRepresentation)

#pragma mark - RESTful JSON Representation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    if (![self isVisibleToUser:user
                        apiApp:apiApp]) {
        return nil;
    }
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // Post properties
    
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    [jsonObject setValue:self.text
                  forKey:@"text"];
    
    // Post Relationships
    
    // creator
    [jsonObject setValue:self.user.username
                  forKey:@"user"];
    
    // parent post
    if (self.parent) {
        [jsonObject setValue:self.parent.id
                      forKey:@"parent"];
    }

    // children posts
    if (self.children.count) {
        
        NSArray *childrenIDs = [self JSONRepresentationForRelationship:@"children"
                                              usingDestinationProperty:@"id"
                                                               forUser:user
                                                                apiApp:apiApp];
        if (childrenIDs.count) {
            
            [jsonObject setValue:childrenIDs
                          forKey:@"children"];
        }
    }
    
    // images
    if (self.images.count) {
        
        NSArray *imagesIDs = [self JSONRepresentationForRelationship:@"images"
                                            usingDestinationProperty:@"id"
                                                             forUser:user
                                                              apiApp:apiApp];
        if (imagesIDs.count) {
            [jsonObject setValue:imagesIDs
                          forKey:@"images"];
        }
    }
    
    // links
    if (self.links.count) {
        
        NSArray *linksIDs = [self JSONRepresentationForRelationship:@"links"
                                           usingDestinationProperty:@"id"
                                                            forUser:user
                                                             apiApp:apiApp];
        
        if (linksIDs.count) {
            [jsonObject setValue:linksIDs
                          forKey:@"links"];
        }
    }
    
    return jsonObject;
}

@end
