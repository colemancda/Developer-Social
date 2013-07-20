//
//  User.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/20/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * permissions;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSManagedObject *image;
@property (nonatomic, retain) NSSet *tokens;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addTeamsObject:(NSManagedObject *)value;
- (void)removeTeamsObject:(NSManagedObject *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addTokensObject:(NSManagedObject *)value;
- (void)removeTokensObject:(NSManagedObject *)value;
- (void)addTokens:(NSSet *)values;
- (void)removeTokens:(NSSet *)values;

- (void)addAccountsObject:(NSManagedObject *)value;
- (void)removeAccountsObject:(NSManagedObject *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end
