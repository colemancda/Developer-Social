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

@property NSURL *packageURL;

@property (readonly) NSURL *sqliteURL;

-(void)open:(completionBlock)completionBlock;

-(void)save:(completionBlock)completionBlock;

#pragma mark - Users

-(User *)userWithUsername:(NSString *)username;

-(NSUInteger)numberOfUsers;

-(User *)createUser;

-(void)removeUser:(User *)user;

#pragma mark - Teams

-(Team *)fetchTeamWithID:(NSUInteger)teamID;


@end
