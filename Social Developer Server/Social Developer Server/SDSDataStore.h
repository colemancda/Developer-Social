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
    NSPersistentStore *_sqliteStore;
}

#pragma mark - Store Actions

-(NSError *)open;

-(void)save:(completionBlock)completionBlock;

#pragma mark - Properties

@property NSURL *packageURL;

#pragma mark

@property (readonly) NSURL *sqliteURL;

@property (readonly) NSURL *preferencesURL;

#pragma mark - Saved Preferences

@property NSUInteger tokenLength;



#pragma mark - Users

-(void)userWithUsername:(NSString *)username
             completion:(void (^) (User *user))completionBlock;

-(void)numberOfUsers:(void (^) (NSUInteger numberOfUsers))completionBlock;

-(void)createUser:(void (^) (User *user))completionBlock;

-(void)removeUser:(User *)user
       completion:(void (^) (void))completionBlock;

#pragma mark - Teams

-(void)teamWithID:(NSUInteger)teamID
       completion:(void (^) (Team *team))completionBlock;

-(void)numberOfTeams:(void (^) (NSUInteger numberOfUsers))completionBlock;

-(void)createTeam:(void (^) (Team *team))completionBlock;

-(void)removeTeam:(Team *)team
       completion:(void (^)(void))completionBlock;

#pragma mark - Posts




@end
