//
//  SDSAppDelegate.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/3/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SDSAppDelegate.h"
#import "CDASQLiteDataStore.h"
#import "SDSServer.h"

@implementation SDSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // App Support Directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    
    // Application Support directory
    NSString *appSupportPath = paths[0];
    
    // get the app bundle identifier
    NSString *folderName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    // use that as app support folder and create it if it doesnt exist
    NSString *appSupportFolder = [appSupportPath stringByAppendingPathComponent:folderName];
    
    BOOL isDirectory;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appSupportFolder
                                                           isDirectory:&isDirectory];
    
    // create folder if it doesnt exist
    if (!isDirectory || !fileExists) {
        
        NSError *error;
        BOOL createdFolder = [[NSFileManager defaultManager] createDirectoryAtPath:appSupportFolder
                                                       withIntermediateDirectories:YES
                                                                        attributes:nil
                                                                             error:&error];
        if (!createdFolder) {
            
            [NSException raise:@"Could not create Application Support folder"
                        format:@"%@", error.localizedDescription];
        }
    }
    
    NSString *sqliteFilePath = [appSupportFolder stringByAppendingPathComponent:@"SDSData.sqlite"];
    
    // load SQLite store
    _sqliteDataStore = [[CDASQLiteDataStore alloc] initWithURL:[NSURL fileURLWithPath:sqliteFilePath]];
    
    _server = [[SDSServer alloc] init];
    
    
}

@end
