//
//  SDSDataStore.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SDSDataStore.h"
#import <CoreData/CoreData.h>
#import "User.h"

@implementation SDSDataStore

- (id)init
{
    self = [super init];
    if (self) {
        
        // load Core Data Model
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // store coodinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // create Context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        _context.undoManager = nil;
        
        // create in memory store
        NSError *inMemoryStoreCreateError;
        _memoryStore = [psc addPersistentStoreWithType:NSInMemoryStoreType
                                         configuration:nil
                                                   URL:nil
                                               options:nil
                                                 error:&inMemoryStoreCreateError];
        if (!_memoryStore) {
            [NSException raise:@"Could not create In-Memory Store"
                        format:@"%@", inMemoryStoreCreateError];
        }
        
        // create admin for empty store
        [self createUser:^(User *user) {
            
            user.username = @"Admin";
            user.password = @"admin";
            user.permissions = [NSNumber numberWithInteger:Admin];
            
        }];
        
    }
    return self;
}

#pragma mark

-(NSURL *)sqliteURL
{
    NSAssert(self.packageURL,
             @"Must have the package URL before you can get the url for the SQLite file");
    
    NSURL *sqliteURL = [self.packageURL URLByAppendingPathComponent:@"data.sqlite"];
    
    return sqliteURL;
}

#pragma mark - Store Actions

-(NSError *)open
{
    // get the store coordinator
    NSPersistentStoreCoordinator *psc = _context.persistentStoreCoordinator;

    // clear context
    [_context reset];
    
    // remove our in memory store
    NSError *removeMemoryStoreError;
    [psc removePersistentStore:_memoryStore
                         error:&removeMemoryStoreError];
    
    if (removeMemoryStoreError) {
        return removeMemoryStoreError;
    }
        
    // create SQLite store from url
    NSError *openSQLiteError;
    _sqliteStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                     configuration:nil
                                               URL:self.sqliteURL
                                           options:nil
                                             error:&openSQLiteError];
    
    if (openSQLiteError) {
        return openSQLiteError;
    }
    
    // migrate SQLite store to In-Memory store
    NSError *migrationError;
    _memoryStore = [psc migratePersistentStore:_sqliteStore
                                         toURL:nil
                                       options:nil
                                      withType:NSInMemoryStoreType
                                         error:&migrationError];
    
    if (migrationError) {
        return migrationError;
    }
    
    // no error
    return nil;
}

-(void)save:(completionBlock)completionBlock
{
    // get the store coordinator
    NSPersistentStoreCoordinator *psc = _context.persistentStoreCoordinator;
    
    [_context performBlock:^{
        
        // if this is a new document
        if (!_sqliteStore) {
            
            // save
            NSError *saveError;
            [_context save:&saveError];
            
            if (saveError) {
                if (completionBlock) {
                    completionBlock(saveError);
                }
                
                return;
            }
            
            // migrate in memory store to sqlite file (create copy of memory store to sql store)...
            NSError *migrationError;
            _sqliteStore = [psc migratePersistentStore:_memoryStore
                                                 toURL:self.sqliteURL
                                               options:nil
                                              withType:NSSQLiteStoreType
                                                 error:&migrationError];
            
            if (migrationError) {
                if (completionBlock) {
                    completionBlock(migrationError);
                }
                
                return;
            }
        }
        
        // if we're saving a opened document
        else {
            
            // add SQLite file
            NSError *loadSQLiteStoreError;
            _sqliteStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:self.sqliteURL
                                                   options:nil
                                                     error:&loadSQLiteStoreError];
            
            if (loadSQLiteStoreError) {
                if (completionBlock) {
                    completionBlock(loadSQLiteStoreError);
                }
                
                return;
            }
            
            // save
            NSError *saveError;
            [_context save:&saveError];
            
            if (saveError) {
                if (completionBlock) {
                    completionBlock(saveError);
                }
                
                return;
            }
            
        }
        
        // remove sqlStore
        NSError *removeSQLiteStoreError;
        [psc removePersistentStore:_sqliteStore
                             error:&removeSQLiteStoreError];
        
        if (removeSQLiteStoreError) {
            if (completionBlock) {
                completionBlock(removeSQLiteStoreError);
            }
            
            return;
        }
        
    }];
}

#pragma mark - User

-(void)userWithUsername:(NSString *)username
             completion:(void (^) (User *user))completionBlock
{
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"UserWithUsername"
                                                      substitutionVariables:@{@"USERNAME": username}];
    
    [_context performBlock:^{
        
        NSError *fetchError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        if (!result.count) {
            
            return;
        }
        
        User *user = result[0];
        
        if (completionBlock) {
            completionBlock(user);
        }
        
    }];
}

-(void)numberOfUsers:(void (^)(NSUInteger))completionBlock
{
    [_context performBlock:^{
       
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        fetchRequest.resultType = NSCountResultType;
        
        NSError *fetchError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        NSNumber *numberOfUsers = result[0];
        
        if (completionBlock) {
            completionBlock(numberOfUsers.integerValue);
        }
    }];
    
}

-(void)createUser:(void (^)(User *))completionBlock
{
    [_context performBlock:^{
       
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                   inManagedObjectContext:_context];
        
        if (completionBlock) {
            completionBlock(user);
        }
        
    }];
}

-(void)removeUser:(User *)user
{
    [_context performBlockAndWait:^{
        
        [_context deleteObject:user];
    }];
}




@end
