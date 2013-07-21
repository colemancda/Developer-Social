//
//  CDAAppDelegate.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDAAppDelegate.h"
#import "CDADataStore.h"

NSString *const CDADataStoreArchivePathUserPreferencesKey = @"CDADataStoreArchivePath";

@implementation CDAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    _dataStore = [CDADataStore sharedStore];
}

+ (NSString *)applicationFilesDirectory
{
    static NSString *applicationFilesDirectory = nil;
    
    if (!applicationFilesDirectory) {
        
        // set default save location
        NSArray *appSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *appSupportDirectoryPath = [appSupportDirectories objectAtIndex:0];
        
        NSString *folderName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
        
        NSString *folderPath = [appSupportDirectoryPath stringByAppendingPathComponent:folderName];
        
        BOOL foundDirectory;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath
                                                               isDirectory:&foundDirectory];
        
        if (!fileExists || !foundDirectory) {
            
            // create app support subfolder folder for our app
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        
        
        applicationFilesDirectory = folderPath;
    }
    
    return applicationFilesDirectory;
}


@end
