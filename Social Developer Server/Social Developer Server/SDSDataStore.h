//
//  SDSDataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CompletionBlock.h"
#import "Link.h"
@class User, Token, Skill, Image, Team, Link, Session, Post;

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

#pragma mark - Common Fetch

-(void)countForEntity:(NSString *)entityName
           completion:(void (^)(NSUInteger count))completionBlock;

-(void)remove:(NSManagedObject *)managedObject
   completion:(void (^) (void))completionBlock;

#pragma mark - Users

-(void)userWithUsername:(NSString *)username
             completion:(void (^) (User *user))completionBlock;

-(void)createUser:(NSString *)username
       completion:(void (^) (User *user))completionBlock;

#pragma mark - Session

-(void)sessionWithToken:(NSString *)token
             completion:(void (^) (Session *session))completionBlock;

-(void)createSessionForUser:(User *)user
                 completion:(void (^) (Session *session))completionBlock;

#pragma mark - Teams

-(void)teamWithID:(NSUInteger)teamID
       completion:(void (^) (Team *team))completionBlock;

-(void)createTeam:(void (^) (Team *team))completionBlock;

@property (readonly) NSUInteger lastTeamID;

#pragma mark - Images

-(void)imageWithID:(NSUInteger)imageID
        completion:(void (^) (Image *image))completionBlock;

-(void)createImage:(void (^) (Image *image))completionBlock;

@property (readonly) NSUInteger lastImageID;

#pragma mark - Post

-(void)postWithID:(NSInteger)postID
       completion:(void (^) (Post *post))completionBlock;

-(void)createPost:(void (^) (Post *post))completionBlock;

@property (readonly) NSUInteger lastPostID;

#pragma mark - Link

-(void)linkWithID:(NSUInteger)linkID
       completion:(void (^)(Link *link))completionBlock;

-(void)createLink:(NSString *)urlString
             type:(LinkType)linkType
       completion:(void (^)(Link *))completionBlock;

@property (readonly) NSUInteger lastLinkID;

@end
