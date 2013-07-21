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
        
        // create NSOperationQueue to 
        
        // read in all Core Data Model files
        _model = [NSManagedObjectModel modelByMergingModels:nil];
        
        // persistent store coordinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // open persistentStore
        NSError *openPersistanceError;
        
        NSPersistentStore *persistentStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:self.archiveURL
                                                                     options:nil
                                                                       error:&openPersistanceError];
        if (!persistentStore) {
            
            [NSException raise:@"Opening Persistance Failed"
                        format:@"%@", openPersistanceError];
            
        }
        
        // create context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [_context performBlockAndWait:^{
            
            _context.persistentStoreCoordinator = psc;
            
            // dont support undo
            _context.undoManager = nil;
            
            // start loading everything from archive into arrays
            [self loadUsers];
            [self loadPosts];
            [self loadTeams];
            [self loadLinks];
            [self loadImages];
            
        }];
        
        NSLog(@"Finished initializing DataStore");
        
    }
    return self;
}

#pragma mark - Store Actions

-(NSError *)save
{
    
    
}

#pragma mark - Loading

-(void)loadUsers
{
    if (!_users) {
        
        
        
    }
}



@end
