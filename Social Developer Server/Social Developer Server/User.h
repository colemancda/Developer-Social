//
//  User.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class APIAppUserPermissions, Image, Post, Session, SiteAccount, Skill, Team, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * permissions;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *adminOfTeams;
@property (nonatomic, retain) NSSet *appPermissions;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *visiblePosts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(SiteAccount *)value;
- (void)removeAccountsObject:(SiteAccount *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addAdminOfTeamsObject:(Team *)value;
- (void)removeAdminOfTeamsObject:(Team *)value;
- (void)addAdminOfTeams:(NSSet *)values;
- (void)removeAdminOfTeams:(NSSet *)values;

- (void)addAppPermissionsObject:(APIAppUserPermissions *)value;
- (void)removeAppPermissionsObject:(APIAppUserPermissions *)value;
- (void)addAppPermissions:(NSSet *)values;
- (void)removeAppPermissions:(NSSet *)values;

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFollowingObject:(User *)value;
- (void)removeFollowingObject:(User *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

- (void)addSkillsObject:(Skill *)value;
- (void)removeSkillsObject:(Skill *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addVisiblePostsObject:(Post *)value;
- (void)removeVisiblePostsObject:(Post *)value;
- (void)addVisiblePosts:(NSSet *)values;
- (void)removeVisiblePosts:(NSSet *)values;

@end
