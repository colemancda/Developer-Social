//
//  CDASQLiteDataStore.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDASQLiteDataStore.h"

@implementation CDASQLiteDataStore

-(id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        
        _sqliteFileURL = url;
        
        // load Core Data Model
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // store coodinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // create Context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        _context.undoManager = nil;
        
        // load SQLite store
        NSError *sqliteStoreError;
        _sqliteStore = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                         configuration:nil
                                                   URL:url
                                               options:nil
                                                 error:&sqliteStoreError];
        if (!sqliteStoreError) {
            
            [NSException raise:@"Could not create SQLite Store"
                        format:@"%@", sqliteStoreError.localizedDescription];
            
        }
        
    }
    return self;
}


- (id)init
{
    [NSException raise:@"Wrong initialization method"
                format:@"You cannot use %@ with '-%@', you have to use '-%@'",
     self,
     NSStringFromSelector(_cmd),
     NSStringFromSelector(@selector(initWithURL:))];
    return nil;
}

#pragma mark - Store Actions

-(void)save:(completionBlock)completionBlock
{
    [_context performBlock:^{
        
        NSError *error;
        [_context save:&error];
        
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

#pragma mark - Common Fetch

-(void)countForEntityWithName:(NSString *)entityName
                   completion:(void (^)(NSUInteger))completionBlock
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

-(void)lastCreatedEntityWithName:(NSString *)entityName
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

-(void)createEntityWithName:(NSString *)entityName
                 completion:(void (^)(NSManagedObject *))completionBlock
{
    [_context performBlock:^{
        
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                   inManagedObjectContext:_context];
        
        if (completionBlock) {
            completionBlock(newObject);
        }
    }];
}

-(void)executeSingleResultFetchRequestTemplateWithName:(NSString *)templateName
                                 substitutionVariables:(NSDictionary *)variables
                                            completion:(void (^)(NSManagedObject *))completionBlock
{
    [_context performBlock:^{
        
        NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:templateName
                                                          substitutionVariables:variables];
        
        NSError *fetchRequestError;
        NSArray *result = [_context executeFetchRequest:fetchRequest
                                                  error:&fetchRequestError];
        
        if (!result) {
            
            [NSException raise:@"Fetch Request Failed"
                        format:@"%@", fetchRequestError.localizedDescription];
            
            return;
        }
        
        if (!result.count) {
            
            if (completionBlock) {
                completionBlock(nil);
            }
            
            return;
        }
        
        NSManagedObject *fetchedObject = result[0];
        
        // check if there are many results (we only expect one)
        if (result.count > 1) {
            
            NSLog(@"%ld %@ were fetched, we only expected 1",
                  result.count, NSStringFromClass(fetchedObject.class));
        }
        
        if (completionBlock) {
            completionBlock(fetchedObject);
        }
        
        return;
    }];
}


@end
