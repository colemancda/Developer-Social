//
//  NSManagedObject+RelationshipJSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "NSManagedObject+RelationshipJSONRepresentation.h"

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

@end
