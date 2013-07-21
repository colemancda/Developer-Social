//
//  CDAAppDelegate.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CDADataStore;

@interface CDAAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly) CDADataStore *dataStore;

@property (readonly) NSURL *applicationFilesDirectory;

- (IBAction)saveAction:(id)sender;

@end
