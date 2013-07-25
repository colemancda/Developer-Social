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
#import "Image.h"
#import "SDSDocument.h"
#import "NSString+RandomString.h"

@implementation SDSDataStore

- (id)init
{
    self = [super init];
    if (self) {
        
        // default document preferences
        self.tokenLength = 10;
        self.refreshUIInterval = 15;
        self.saveInterval = 60 * 2;
        
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
        
        // create images memory dictionary
        _memoryImages = [[NSMutableDictionary alloc] init];
        _memoryImagesOperationQueue = [[NSOperationQueue alloc] init];
        _memoryImagesOperationQueue.maxConcurrentOperationCount = 1; // serialized so we dont corrupt the dicitonary
        
        // create admin for empty store
        [self createUser:@"Admin" completion:^(User *user) {

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

-(NSURL *)savedValuesURL
{
    NSAssert(self.packageURL,
             @"Must have the package URL before you can get the url for the SavedValues file");
    
    return [self.packageURL URLByAppendingPathComponent:@"savedValues.plist"];
}

#pragma mark - Store Actions

-(NSError *)open
{
    NSAssert(self.packageURL, @"Can't open SDSDataStore without a valid URL");
    
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
    
    // import preferences if file exists (it's optional to have it)
    if (preferencesDictionary ||
        [preferencesDictionary isKindOfClass:[NSDictionary class]]) {
        
        NSNumber *tokenLength = [preferencesDictionary objectForKey:@"tokenLength"];
        
        if (tokenLength) {
            self.tokenLength = tokenLength.integerValue;
        }
        
        NSNumber *saveInterval = [preferencesDictionary objectForKey:@"saveInterval"];
        if (saveInterval) {
            self.saveInterval = saveInterval.integerValue;
        }
        
        NSNumber *refreshUIInterval = [preferencesDictionary objectForKey:@"refreshUIInterval"];
        if (refreshUIInterval) {
            self.refreshUIInterval = refreshUIInterval.integerValue;
        }
        
    }
    
    // open savedValues
    NSDictionary *savedValuesDictionary = [NSDictionary dictionaryWithContentsOfURL:self.savedValuesURL];
    
    NSString *invalidSavedValuesErrorDescription = NSLocalizedString(@"Invalid SavedValues file",
                                                                     @"Invalid SavedValues file");
    
    NSError *invalidSavedValuesError = [NSError errorWithDomain:kSDSDomain
                                                           code:100
                                                       userInfo:@{NSLocalizedDescriptionKey: invalidSavedValuesErrorDescription}];
    
    // error if file doesnt exist (it's obligatory to have it)
    if (!savedValuesDictionary ||
        ![savedValuesDictionary isKindOfClass:[NSDictionary class]]) {
        
        return invalidSavedValuesError;
    }
    
    // get values
    NSNumber *lastTeamID = [savedValuesDictionary objectForKey:@"lastTeamID"];
    NSNumber *lastImageID = [savedValuesDictionary objectForKey:@"lastImageID"];
    NSNumber *lastPostID = [savedValuesDictionary objectForKey:@"lastPostID"];
    NSNumber *lastLinkID = [savedValuesDictionary objectForKey:@"lastLinkID"];
    
    if (!lastPostID ||
        !lastLinkID ||
        !lastImageID ||
        !lastTeamID)
    {
        return invalidSavedValuesError;
        
    }
    
    // load saved values
    _lastTeamID = lastTeamID.integerValue;
    _lastPostID = lastPostID.integerValue;
    _lastImageID = lastImageID.integerValue;
    _lastLinkID = lastLinkID.integerValue;
    
    // no error
    return nil;
}

-(void)save:(completionBlock)completionBlock
{
    NSAssert(self.packageURL, @"Can't save SDSDataStore to file without a valid URL");
    
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
        NSDictionary *preferencesDictionary = @{@"tokenLength":
                                                    [NSNumber numberWithInteger:self.tokenLength],
                                                @"saveInterval" :
                                                    [NSNumber numberWithInteger:self.saveInterval],
                                                @"refreshUIInterval" :
                                                    [NSNumber numberWithInteger:self.refreshUIInterval]};
        
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
        
        // save SavedValues dictionary
        NSDictionary *savedValues = @{@"lastTeamID": [NSNumber numberWithInteger:self.lastTeamID],
                                      @"lastImageID" : [NSNumber numberWithInteger:self.lastImageID],
                                      @"lastPostID" : [NSNumber numberWithInteger:self.lastPostID],
                                      @"lastLinkID" : [NSNumber numberWithInteger:self.lastLinkID]};
        
        BOOL wroteSavedValuesToDisk = [savedValues writeToURL:self.savedValuesURL
                                                   atomically:YES];
        
        if (!wroteSavedValuesToDisk) {
            
            NSString *errorDescription = NSLocalizedString(@"Could not save document values",
                                                           @"Could not save document values");
            
            NSError *writeSavedValuesError = [NSError errorWithDomain:kSDSDomain
                                                                code:100
                                                            userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
            if (completionBlock) {
                completionBlock(writeSavedValuesError);
            }
            
            return;
            
        }
        
        if (completionBlock) {
            completionBlock(nil);
        }
        
        return;
        
    }];
}

#pragma mark - Common Fetch

-(void)countForEntity:(NSString *)entityName
           completion:(void (^)(NSUInteger count))completionBlock
{
    [_context performBlock:^{
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        fetchRequest.resultType = NSCountResultType;
        
        NSError *fetchError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchError.localizedDescription];
            return;
        }
        
        NSNumber *count = result[0];
        
        if (completionBlock) {
            completionBlock(count.integerValue);
        }
        
    }];
}

-(void)remove:(NSManagedObject *)managedObject
   completion:(void (^)(void))completionBlock
{
    [_context performBlock:^{
       
        [_context deleteObject:managedObject];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

-(void)lastCreatedEntity:(NSString *)entityName
                sortedBy:(NSString *)propertyToSortBy
              completion:(void (^)(NSManagedObject *))completionBlock
{
    // create fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:propertyToSortBy
                                                           ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
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
        
        NSManagedObject *lastObject = result.lastObject;
        
        if (completionBlock) {
            completionBlock(lastObject);
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

-(void)createUser:(NSString *)username
       completion:(void (^)(User *))completionBlock
{
    assert(username);
    
    [_context performBlock:^{
       
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                   inManagedObjectContext:_context];
        
        user.username = username;
        
        if (completionBlock) {
            completionBlock(user);
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


#pragma mark - Image

-(void)imageWithID:(NSUInteger)imageID
        completion:(void (^)(Image *))completionBlock
{
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"ImageWithID"
                                                      substitutionVariables:@{@"ID": [NSNumber numberWithInteger:imageID]}];
    
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
        
        Image *image = result[0];
        
        if (completionBlock) {
            completionBlock(image);
        }
    }];
}

-(void)createImage:(NSData *)imageData
          filename:(NSString *)filename
        completion:(void (^)(Image *))completionBlock
{
    [_context performBlock:^{
        
        Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                                     inManagedObjectContext:_context];
        
        // set ID
        NSUInteger imageID = self.lastImageID + 1;
        
        image.id = [NSNumber numberWithInteger:imageID];
        
        _lastImageID = imageID;
        
        // set filename
        image.filename = filename;
        
        [_memoryImagesOperationQueue addOperationWithBlock:^{
            
            // save to memory
            NSString *imageIDString = [NSString stringWithFormat:@"%@", image.id];
            [_memoryImages setObject:imageData
                              forKey:imageIDString];
            
            if (completionBlock) {
                completionBlock(image);
            }
        }];
    }];
}

-(NSData *)imageDataForImage:(Image *)image
{
    assert(image);
    
    // check if image is in memory or has been saved...
    
    NSString *imageIDString = [NSString stringWithFormat:@"%@", image.id];
    
    // if we have it in our temp store
    NSData *imageData = [_memoryImages objectForKey:imageIDString];
    if (imageData) {
        
        return imageData;
    }
    
    // get data from disk
    NSURL *imageDataURL = [self urlForImage:image];
    imageData = [NSData dataWithContentsOfURL:imageDataURL];
    return imageData;
}

#pragma mark - Link

-(void)linkWithID:(NSUInteger)linkID
       completion:(void (^)(Link *))completionBlock
{
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"LinkWithID"
                                                      substitutionVariables:@{@"ID": [NSNumber numberWithInteger:linkID]}];
    
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
        
        Link *link = result[0];
        
        if (completionBlock) {
            completionBlock(link);
        }
        
    }];
}

-(void)createLink:(NSString *)urlString
             type:(LinkType)linkType
       completion:(void (^)(Link *))completionBlock
{
    [_context performBlock:^{
       
        Link *link = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                   inManagedObjectContext:_context];
        
        // set ID
        NSUInteger linkID = self.lastLinkID + 1;
        
        link.id = [NSNumber numberWithInteger:linkID];
        
        _lastLinkID = linkID;
        
        // set linkType
        link.type = [NSNumber numberWithInteger:linkType];
        
        if (completionBlock) {
            completionBlock(link);
        }
    }];
}

#pragma mark - Post

-(void)postWithID:(NSInteger)postID
       completion:(void (^)(Post *))completionBlock
{
    NSDictionary *requestVariables = @{@"ID": [NSNumber numberWithInteger:postID]};
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"PostWithID"
                                                      substitutionVariables:requestVariables];
    
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
        
        Post *post = result[0];
        
        if (completionBlock) {
            completionBlock(post);
        }
        
    }];
}

-(void)createPost:(void (^)(Post *))completionBlock
{
    [_context performBlock:^{
       
        Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post"
                                                   inManagedObjectContext:_context];
        
        NSUInteger postID = self.lastPostID + 1;
        
        post.id = [NSNumber numberWithInteger:postID];
        
        _lastPostID = postID;
        
        if (completionBlock) {
            completionBlock(post);
        }
        
    }];
}


@end
