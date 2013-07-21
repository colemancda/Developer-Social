//
//  CDAAppDelegate.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDAAppDelegate.h"
#import "CDADataStore.h"

@implementation CDAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    _dataStore = [CDADataStore sharedStore];
}


- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *folderName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    NSURL *folderURL = [appSupportURL URLByAppendingPathComponent:folderName
                                                      isDirectory:YES];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderURL.filePathURL.absoluteString])
    {
        [[NSFileManager defaultManager] createDirectoryAtURL:folderURL
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    
    return folderURL;
}



@end
