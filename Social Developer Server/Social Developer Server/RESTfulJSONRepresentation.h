//
//  RESTfulJSONRepresentation.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RESTfulJSONRepresentation <NSObject>

-(NSDictionary *)JSONRepresentationForUser:(User *)user;

@end
