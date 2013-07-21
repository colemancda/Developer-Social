//
//  CDADataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CompletionBlock.h"
@class User, Token, Skill, Image, Team, Link;

@interface CDADataStore : NSObject
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
    
    NSManagedObjectContext *_tempContext;
}

+ (CDADataStore *)sharedStore;

#pragma mark - Store Actions

@property (readonly) NSURL *archiveURL;

-(void)save:(completionBlock)completionBlock;

#pragma mark - Users

-(void)fetchUserWithUsername:(NSString *)username
                  completion:(void (^)(User *user))completionBlock;

-(void)fetchNumberOfUsers:(void (^)(NSUInteger numberOfUsers))completionBlock;

-(void)createUser:(void (^)(User *user))completionBlock;

-(void)removeUser:(User *)user
       completion:(void (^)(void))completionBlock;

#pragma mark - Teams

-(void)fetchTeamWithID:(NSUInteger)teamID completion:(void (^)(Team *team))completionBlock;






@end
