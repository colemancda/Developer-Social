//
//  User+JSONRepresentation.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User+JSONRepresentation.h"
#import "SDSDataModels.h"
#import "NSManagedObject+RelationshipJSONRepresentation.h"
#import "NSDate+CDAStringRepresentation.h"
#import "Skill+JSONRepresentation.h"
#import "SiteAccount+JSONRepresentation.h"
#import "User+Visibility.h"

@implementation User (JSONRepresentation)

#pragma mark - RESTful JSON Representation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
                                    apiApp:(APIApp *)apiApp
{
    AssertUserForSDSJSON
    AssertAPIAppForSDSJSON
    
    if (![self isVisibleToUser:user
                        apiApp:apiApp]) {
        
        return nil;
    }
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
        
    // date joined
    [jsonObject setValue:self.date.stringValue
                  forKey:@"date"];
    
    // website
    if (self.website) {
        [jsonObject setValue:self.website
                      forKey:@"website"];
    }
    
    // location
    if (self.location) {
        [jsonObject setValue:self.location
                      forKey:@"location"];
    }
    
    // about
    if (self.about) {
        [jsonObject setValue:self.about
                      forKey:@"about"];
    }
    
    // image
    if (self.image) {
        
        // attach ID
        [jsonObject setValue:self.image.id
                      forKey:@"image"];
    }
    
    // skills
    if (self.skills.count) {
        
        NSMutableArray *skillsInfo = [[NSMutableArray alloc] init];
        
        for (Skill *skill in self.skills) {
            
            // 'Skill' ignores who is making the request
            [skillsInfo addObject:[skill JSONRepresentationForUser:user
                                                            apiApp:apiApp]];
            
        }
        
        // get the name for each skill
        [jsonObject setValue:skillsInfo
                      forKey:@"skills"];
    }
    
    // teams
    if (self.teams.count) {
        
        // get team IDs
        [jsonObject setValue:self.teamIDs
                      forKey:@"teams"];
    }
    
    // other site accounts
    if (self.accounts.count) {
        
        // get public account info
        NSMutableArray *accountsInfo = [[NSMutableArray alloc] init];
        
        for (SiteAccount *siteAccount in self.accounts) {
            
            // 'SiteAccount' ignores who is making the request
            [accountsInfo addObject:[siteAccount JSONRepresentationForUser:user
                                                                    apiApp:apiApp]];
        }
        
        [jsonObject setValue:accountsInfo
                      forKey:@"accounts"];
    }
    
    // followers
    if (self.followers.count) {
        
        [jsonObject setValue:self.followersUsernames
                      forKey:@"followers"];
    }
    
    // following
    if (self.following.count) {
        
        [jsonObject setValue:self.followingUsernames
                      forKey:@"following"];
    }
    
    // posts
    if (self.posts.count) {
        
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        
        for (Post *post in self.posts) {
            
            // only add posts that are visible for the user requesting this representation
            if ([post isVisibleToUser:user]) {
                
                [posts addObject:post.id];
            }
        }
        
        // add to jsonObject if at least 1 post is visible
        if (posts.count) {
            [jsonObject setValue:posts
                          forKey:@"posts"];
        }
    }
    
    // Private properties
    if (user == self ||
        user.permissions.integerValue == Admin) {
        
        // password
        [jsonObject setValue:self.password
                      forKey:@"password"];
        
        // permissions level
        [jsonObject setValue:self.permissions
                      forKey:@"permissions"];
        
    }
    
    
    return jsonObject;
}

#pragma mark

-(NSArray *)teamIDs
{
    return [self JSONRepresentationForRelationship:@"teams"
                          usingDestinationProperty:@"id"];
}

-(NSArray *)followersUsernames
{
    return [self JSONRepresentationForRelationship:@"followers"
                          usingDestinationProperty:@"username"];
}

-(NSArray *)followingUsernames
{
    return [self JSONRepresentationForRelationship:@"following"
                          usingDestinationProperty:@"username"];
}

@end