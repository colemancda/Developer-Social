//
//  SDSDocument.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SDSDataStore;

extern NSString *const kSDSDomain;

@interface SDSDocument : NSDocument

@property (readonly) SDSDataStore *dataStore;

#pragma mark - UI

@property (strong) IBOutlet NSTextField *numberOfUsersTextField;

@property (strong) IBOutlet NSTextField *lastUserTextField;


#pragma mark - UI Fetch Values

-(void)refreshNumberOfUsers;

-(void)refreshLastUser;

@end
