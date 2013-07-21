//
//  SDSDataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CompletionBlock.h"
@class User, Token, Skill, Image, Team, Link;

@interface SDSDataStore : NSObject
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
    
    NSPersistentStore *_memoryStore;
}

#pragma mark - Store Actions

@property NSURL *packageURL;

@property (readonly) NSURL *sqliteURL;

-(NSError *)open;

-(NSError *)save;

#pragma mark - Users

-(void)userWithUsername:(NSString *)username
             completion:(completionBlock)completionBlock;

-(void)numberOfUsers:(void (^) (NSUInteger numberOfUsers))completionBlock;

-(void)createUser:(void (^) (User *user))completionBlock;

-(void)removeUser:(User *)user
       completion:(void (^) (void))completionBlock;

#pragma mark - Teams

-(void)fetchTeamWithID:(NSUInteger)teamID
            completion:(void (^) (Team *team))completionBlock;


@end
