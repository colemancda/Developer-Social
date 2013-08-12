//
//  RESTfulJSONRepresentation.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RESTfulJSONRepresentation <NSObject>

// Properties that are public, can be seen by anyone accessing the RESTful object with GET and no authorization
@property (readonly) NSDictionary *publicInfo;

// Properties that INCLUDE the public + private, can be seen only by yourself if you own the RESTful object or an Admin
@property (readonly) NSDictionary *allInfo;

@end
