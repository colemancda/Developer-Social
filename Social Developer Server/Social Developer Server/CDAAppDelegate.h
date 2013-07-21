//
//  CDAAppDelegate.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CDADataStore;

extern NSString *const CDADataStoreArchivePathUserPreferencesKey;

@interface CDAAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly) CDADataStore *dataStore;

+ (NSString *)applicationFilesDirectory;

- (IBAction)saveAction:(id)sender;

@end
