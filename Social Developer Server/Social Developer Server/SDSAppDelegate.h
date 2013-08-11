//
//  SDSAppDelegate.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/3/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CDASQLiteDataStore, SDSServer;

@interface SDSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly) CDASQLiteDataStore *sqliteDataStore;

@property (readonly) SDSServer *server;

-(void)setupServer;

@end
