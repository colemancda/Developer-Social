//
//  SDSDataStore.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SDSDataStore.h"
#import "CDASQLiteDataStore.h"

@implementation SDSDataStore

+ (SDSDataStore *)sharedStore
{
    static SDSDataStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // load SQLite file
        _sqliteDataStore = [[CDASQLiteDataStore alloc] initWithURL:[NSURL fileURLWithPath:self.sqliteFilePath]];
        
        // load Count file (if it exists)
        NSDictionary *countDictionary = [NSDictionary dictionaryWithContentsOfFile:self.countPlistFilePath];
        
        if (countDictionary) {
            
            NSNumber *imageID = countDictionary[@"lastImageID"];
            _lastImageID
            
        }
        
    }
    return self;
}

#pragma mark - Generated URLs

-(NSString *)appSupportDirectory
{
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
    
    return appSupportFolder;
}

-(NSString *)sqliteFilePath
{
    return [self.appSupportDirectory stringByAppendingPathComponent:@"SDSData.sqlite"];
}

-(NSString *)countPlistFilePath
{
    return [self.appSupportDirectory stringByAppendingPathComponent:@"count.plist"];
}



@end
