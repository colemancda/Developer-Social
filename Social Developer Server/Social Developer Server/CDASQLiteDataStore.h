//
//  CDASQLiteDataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CompletionBlock.h"

@interface CDASQLiteDataStore : NSObject
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
    
    NSPersistentStore *_sqliteStore;
}

-(id)initWithURL:(NSURL *)url;

#pragma mark - Store Actions

-(void)save:(completionBlock)completionBlock;

#pragma mark - Property

@property (readonly) NSURL *sqliteFileURL;

#pragma mark - Common Fetch

-(void)lastCreatedEntityWithName:(NSString *)entityName
                        sortedBy:(NSString *)propertyToSortBy
                      completion:(void (^)(NSManagedObject *lastObject))completionBlock;

-(void)countForEntityWithName:(NSString *)entityName
                   completion:(void (^)(NSUInteger count))completionBlock;

-(void)remove:(NSManagedObject *)managedObject
   completion:(void (^) (void))completionBlock;

-(void)createEntityWithName:(NSString *)entityName
                 completion:(void (^) (NSManagedObject *createdEntity))completionBlock;

-(void)executeSingleResultFetchRequestTemplateWithName:(NSString *)templateName
                                 substitutionVariables:(NSDictionary *)variables
                                            completion:(void (^) (NSManagedObject *fetchedObject))completionBlock;

@end
