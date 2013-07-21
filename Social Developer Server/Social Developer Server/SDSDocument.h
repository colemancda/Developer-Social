//
//  SDSDocument.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SDSDataStore;

@interface SDSDocument : NSDocument

@property (readonly) SDSDataStore *dataStore;

@end
