//
//  CDADataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDADataStore : NSObject
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
}

+ (CDADataStore *)sharedStore;

#pragma mark - Store Actions

@property (readonly) NSString *archivePath;

-(BOOL)save;

#pragma mark - Collections

@property (readonly) NSSet *users;

@property (readonly) NSArray *teams;

@property (readonly) NSArray *posts;

@property (readonly) NSArray *images;

@property (readonly) NSArray *links;

#pragma mark - Loading

-(void)loadUsers;

-(void)loadTeams;

-(void)loadPosts;

-(void)loadImages;

-(void)loadLinks;

#pragma mark - Users

-(NSManagedObject *)createUser;

-(void)removeUser:(NSManagedObject *)user;






@end
