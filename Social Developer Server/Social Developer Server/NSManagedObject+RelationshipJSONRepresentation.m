//
//  NSManagedObject+RelationshipJSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "NSManagedObject+RelationshipJSONRepresentation.h"
#import "SDSVisibility.h"

@implementation NSManagedObject (RelationshipJSONRepresentation)

-(NSArray *)JSONRepresentationForRelationship:(NSString *)relationship
                     usingDestinationProperty:(NSString *)propertyName
{
    NSMutableArray *jsonRepresentation = [[NSMutableArray alloc] init];
    
    NSSet *relationshipSet = [self valueForKey:relationship];
    
    for (NSManagedObject *destinationObject in relationshipSet) {
        
        // must be a Foundation class that is JSON-compatible
        NSObject *property = [destinationObject valueForKey:propertyName];
        
        [jsonRepresentation addObject:property];
    }
    
    return jsonRepresentation;
}

-(NSArray *)JSONRepresentationForRelationship:(NSString *)relationship
                     usingDestinationProperty:(NSString *)propertyName
                                      forUser:(User *)user
                                       apiApp:(APIApp *)apiApp
{
    NSMutableArray *jsonRepresentation = [[NSMutableArray alloc] init];
    
    NSSet *relationshipSet = [self valueForKey:relationship];
    
    for (NSManagedObject *destinationObject in relationshipSet) {
        
        // must be a Foundation class that is JSON-compatible
        NSObject *property = [destinationObject valueForKey:propertyName];
        
        // only add if the object is visible
        id<SDSVisibility> visibleObject = (id<SDSVisibility>)destinationObject;
        
        if ([visibleObject isVisibleToUser:user
                                    apiApp:apiApp]) {
            
            [jsonRepresentation addObject:property];
        }
    }
    
    return jsonRepresentation;
}

@end
