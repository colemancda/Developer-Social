//
//  User.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, UserPermissions) {
  
    DefaultPermissions = 0,
    Moderator = 98,
    Admin = 99
    
};

@class Image, Post, Session, SiteAccount, Team;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * permissions;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *teams;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(SiteAccount *)value;
- (void)removeAccountsObject:(SiteAccount *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
