//
//  NSManagedObject+RelationshipJSONRepresentation.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (RelationshipJSONRepresentation)

// Destination's Property must be JSON compatible Foundation object
-(NSArray *)JSONRepresentationForRelationship:(NSString *)relationship
                     usingDestinationProperty:(NSString *)propertyName;

@end
