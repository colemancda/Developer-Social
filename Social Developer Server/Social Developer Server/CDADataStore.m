//
//  CDADataStore.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDADataStore.h"


@implementation CDADataStore

+ (CDADataStore *)sharedStore
{
    static CDADataStore *sharedStore = nil;
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
        
        NSLog(@"Initializing DataStore...");
        
        // read in all Core Data Model files
        _model = [NSManagedObjectModel modelByMergingModels:nil];
        
        // persistent store coordinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // where to save SQL file
        NSURL *persistanceURL = [NSURL fileURLWithPath:self.archivePath];
        
        // open persistentStore
        NSError *openPersistanceError;
        
        NSPersistentStore *persistentStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:persistanceURL
                                                                     options:nil
                                                                       error:&openPersistanceError];
        if (!persistentStore) {
            
            [NSException raise:@"Opening Persistance Failed"
                        format:@"%@", openPersistanceError];
            
        }
        
        // create context
        _context = [NSManagedObjectContext]
        
        
    }
    return self;
}

#pragma mark - Store Actions

-(NSString *)archivePath
{
    
    
}

-(BOOL)save
{
    
    
}

#pragma mark - Loading





@end
