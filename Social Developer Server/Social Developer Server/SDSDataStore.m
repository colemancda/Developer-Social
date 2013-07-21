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

#pragma mark

-(NSURL *)sqliteURL
{
    NSAssert(self.packageURL,
             @"Must have the package URL before you can get the url for the SQLite file");
    
    NSURL *sqliteURL = [self.packageURL URLByAppendingPathComponent:@"data.sqlite"];
    
}

#pragma mark - Store Actions

-(void)open:(completionBlock)completionBlock
{
    
    
}

-(void)save:(completionBlock)completionBlock
{
    [_context performBlock:^{
        
        
        
    }];
}

#pragma mark - User

-(User *)userWithUsername:(NSString *)username
{
    NSFetchRequest *fetchRequest = [_model fetchRequestFromTemplateWithName:@"UserWithUsername"
                                                      substitutionVariables:@{@"USERNAME": username}];
    
    __block User *user;
    [_context performBlockAndWait:^{
        
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
        
        user = result[0];
        
    }];
    
    return user;
}

-(NSUInteger)numberOfUsers
{
    __block NSUInteger numberOfUsers = 0;
    [_context performBlockAndWait:^{
        
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
        
        NSNumber *count = result[0];
        
        numberOfUsers = count.integerValue;
        
    }];
    
    return numberOfUsers;
}

-(User *)createUser
{
    __block User *user;
    [_context performBlockAndWait:^{
        
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:_context];
        
    }];
    
    return user;
}

-(void)removeUser:(User *)user
{
    [_context performBlockAndWait:^{
        
        [_context deleteObject:user];
    }];
}


@end
