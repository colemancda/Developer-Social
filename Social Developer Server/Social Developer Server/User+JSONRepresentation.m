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

@implementation User (JSONRepresentation)

#pragma mark - RESTful JSON Repressentation Protocol

-(NSDictionary *)JSONRepresentationForUser:(User *)user
{
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    
    // public info
    
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
        
        // get the name for each skill
        [jsonObject setValue:self.skillsNames
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
            
            [accountsInfo addObject:[siteAccount JSONRepresentationForUser:user]];
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
            
            if ([post isVisibleToUser:user]) {
                
                [posts addObject:[post.id]];
            }
        }
        
        if (posts.count) {
            [jsonObject setValue:posts
                          forKey:@"posts"];
        }
    }
    
}

-(NSDictionary *)allInfo
{
    NSMutableDictionary *allInfo = [[NSMutableDictionary alloc] initWithDictionary:self.publicInfo];
    
    // complete info for site accounts
    if (self.accounts.count) {
        
        // get public account info
        NSMutableArray *accountsInfo = [[NSMutableArray alloc] init];
        
        for (SiteAccount *siteAccount in self.accounts) {
            
            [accountsInfo addObject:siteAccount.allInfo];
        }
        
        [allInfo setValue:accountsInfo
                      forKey:@"accounts"];
    }
    
    // password
    [allInfo setValue:self.password
               forKey:@"password"];
    
    // permissions level
    [allInfo setValue:self.permissions
               forKey:@"permissions"];
    
    //
    
}

#pragma mark

-(NSArray *)skillsNames
{
    return [self JSONRepresentationForRelationship:@"skills"
                          usingDestinationProperty:@"name"];
}

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
