//
//  CDADataStore.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDADataStore.h"
#import "CDAAppDelegate.h"
#import "User.h"
#import "Session.h"
#import "Team.h"
#import "Post.h"
#import "Link.h"

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
        _context.persistentStoreCoordinator = psc;
        _context.undoManager = nil;
        
        // create memory only context
        _tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _tempContext.undoManager = nil;
        _tempContext.parentContext = _context;
        
        // load admin
        [self fetchNumberOfUsers:^(NSUInteger numberOfUsers) {
            
            
            
        }];
        
        NSLog(@"Finished initializing DataStore");
        
    }
    return self;
}

#pragma mark

-(NSURL *)archiveURL
{
    NSString *archivePackagePath = [[CDAAppDelegate applicationFilesDirectory] stringByAppendingPathComponent:@"SocialDeveloperServer.sdsdata"];
    
    // create package if it doesnt exist
    BOOL isDirectory;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:archivePackagePath
                                                           isDirectory:&isDirectory];
    
    if (!fileExists || !isDirectory) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:archivePackagePath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
    }
    
    NSString *sqlPath = [archivePackagePath stringByAppendingPathComponent:@"data.sqlite"];
    return [NSURL fileURLWithPath:sqlPath];
}

#pragma mark - Store Actions

-(void)save:(completionBlock)completionBlock
{
    [_tempContext performBlockAndWait:^{
        
        NSError *saveTempError;
        [_tempContext save:&saveTempError];
        
        if (saveTempError) {
            if (completionBlock) {
                completionBlock(saveTempError);
            }
            
            return;
        }
        
        [_context performBlock:^{
            
            NSError *saveMainContextError;
            [_context save:&saveMainContextError];
            
            if (completionBlock) {
                
                if (saveMainContextError) {
                    completionBlock(saveMainContextError);
                }
                else {
                    completionBlock(nil);
                }
            }
            
            return;
        }];
        
    }];
}

#pragma mark - User

-(void)fetchUserWithUsername:(NSString *)username
                  completion:(void (^)(User *))completionBlock
{
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"UserWithUsername"
                                                      substitutionVariables:@{@"USERNAME": username}];
    [_tempContext performBlock:^{
        
        NSError *fetchError;
        NSArray *result = [_tempContext executeFetchRequest:fetchRequest
                                                      error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        if (!result.count) {
            
            completionBlock(nil);
            
            return;
        }
        
        User *user = result[0];
        
        completionBlock(user);
        
        return;
        
    }];
}

-(void)fetchNumberOfUsers:(void (^)(NSUInteger))completionBlock
{    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetchRequest.resultType = NSCountResultType;
    
    [_tempContext performBlock:^{
        
        NSError *fetchError;
        NSArray *result = [_tempContext executeFetchRequest:fetchRequest
                                                      error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        
        
    }];
}


@end
