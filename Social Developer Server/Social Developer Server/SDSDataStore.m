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
#import "Team.h"
#import "Post.h"
#import "Link.h"
#import "Session.h"
#import "SDSDocument.h"
#import "NSString+RandomString.h"

@implementation SDSDataStore

- (id)init
{
    self = [super init];
    if (self) {
        
        // default document preferences
        self.tokenLength = 10;
        
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

-(NSURL *)preferencesURL
{
    NSAssert(self.packageURL,
             @"Must have the package URL before you can get the url for the Preferences file");
    
    return [self.packageURL URLByAppendingPathComponent:@"preferences.plist"];
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
    
    // open preferences file...
    NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfURL:self.preferencesURL];
    
    // import preferences if file exists
    if (preferencesDictionary ||
        [preferencesDictionary isKindOfClass:[NSDictionary class]]) {
        
        NSNumber *tokenLength = [preferencesDictionary objectForKey:@"tokenLength"];
        
        if (tokenLength) {
            self.tokenLength = tokenLength.integerValue;
        }
        
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
        
        // save preferences dictionary
        NSDictionary *preferencesDictionary = @{@"tokenLength": [NSNumber numberWithInteger:self.tokenLength]};
        
        BOOL savedPreferences = [preferencesDictionary writeToURL:self.preferencesURL
                                                       atomically:YES];
        
        if (!savedPreferences) {
            
            NSString *errorDescription = NSLocalizedString(@"Could not save document Preferences",
                                                           @"Could not save document Preferences");
            
            NSError *savePreferencesError = [NSError errorWithDomain:kSDSDomain
                                                                code:100
                                                            userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
            if (completionBlock) {
                completionBlock(savePreferencesError);
            }
            
            return;
        }
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
        return;
        
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
            
            if (completionBlock) {
                completionBlock(nil);
            }
            
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
       completion:(void (^)(void))completionBlock
{
    [_context performBlockAndWait:^{
        
        [_context deleteObject:user];
        
        if (completionBlock) {
            completionBlock();
        }
        
    }];
}

#pragma mark - Teams

-(void)teamWithID:(NSUInteger)teamID
       completion:(void (^)(Team *))completionBlock
{
    [_context performBlock:^{
        
        NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"TeamWithID"
                                                          substitutionVariables:@{@"ID": [NSNumber numberWithInteger:teamID]}];
        
        NSError *fetchError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
            
        }
        
        if (!result.count) {
            
            if (completionBlock) {
                completionBlock(nil);
            }
            
            return;
        }
        
        Team *team = result[0];
        
        if (completionBlock) {
            completionBlock(team);
        }
        
    }];
}

-(void)numberOfTeams:(void (^)(NSUInteger))completionBlock
{
    [_context performBlock:^{
       
        NSFetchRequest *fetchRequest = [_model fetchRequestTemplateForName:@"AllTeams"];
        fetchRequest.resultType = NSCountResultType;
        
        NSError *fetchError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        NSNumber *numberOfTeams = result[0];
        
        if (completionBlock) {
            completionBlock(numberOfTeams.integerValue);
        }
        
    }];
}

-(void)createTeam:(void (^)(Team *))completionBlock
{
    [_context performBlock:^{
       
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team"
                                                   inManagedObjectContext:_context];
        
        // set ID...
        NSUInteger teamID = self.lastTeamID + 1;
        
        team.id = [NSNumber numberWithInteger:teamID];
        
        _lastTeamID = teamID;
        
        if (completionBlock) {
            completionBlock(team);
        }
        
    }];
}

-(void)removeTeam:(Team *)team
       completion:(void (^)(void))completionBlock
{
    [_context performBlock:^{
       
        [_context deleteObject:team];
        
        if (completionBlock) {
            completionBlock();
        }
        
    }];
}

#pragma mark - Session

-(void)sessionWithToken:(NSString *)token
             completion:(void (^) (Session *session))completionBlock
{
    assert(token);
    
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"SessionWithToken"
                                                      substitutionVariables:@{@"TOKEN": token}];
    
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
            
            if (completionBlock) {
                completionBlock(nil);
            }
            
            return;
        }
        
        Session *session = result[0];
        
        if (completionBlock) {
            completionBlock(session);
        }
        
    }];
}

-(void)createSessionForUser:(User *)user
                 completion:(void (^) (Session *session))completionBlock
{
    assert(user);
    
    [_context performBlock:^{
       
        Session *session = [NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                                         inManagedObjectContext:_context];
        
        // set token
        session.token = [NSString randomStringWithLength:self.tokenLength];
        
        // set user
        session.user = user;
        
        if (completionBlock) {
            completionBlock(session);
        }
        
    }];
}

-(void)removeSession:(Session *)session
          completion:(void (^) (void))completionBlock
{
    [_context performBlock:^{
        
        [_context deleteObject:session];
        
        if (completionBlock) {
            completionBlock();
        }
        
    }];
}

#pragma mark - Post




@end
