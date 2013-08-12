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

@implementation User (JSONRepresentation)

#pragma mark - RESTful JSON Repressentation Protocol

-(NSDictionary *)publicInfo
{
    NSMutableDictionary *publicInfo = [[NSMutableDictionary alloc] init];
    
    // date joined
    [publicInfo setValue:self.date
                  forKey:@"date"];
    
    // website
    if (self.website) {
        [publicInfo setValue:self.website
                      forKey:@"website"];
    }
    
    // location
    if (self.location) {
        [publicInfo setValue:self.location
                      forKey:@"location"];
    }
    
    // about
    if (self.about) {
        [publicInfo setValue:self.about
                      forKey:@"about"];
    }
    
    // image
    if (self.image) {
        
        // attach ID
        [publicInfo setValue:self.image.id
                      forKey:@"image"];
    }
    
    // skills
    if (self.skills.count) {
        
        // get the name for each skill
        [publicInfo setValue:self.skillsNames
                      forKey:@"skills"];
    }
    
    // teams
    if (self.teams.count) {
        
        // get team IDs
        [publicInfo setValue:self.teamIDs
                      forKey:@"teams"];
    }
    
    // other site accounts
    if (self.accounts.count) {
        
        // get public account info
        NSArray *accountsInfo = [self JSONRepresentationForRelationship:@"accounts"
                                               usingDestinationProperty:@"username"];
        
        [publicInfo setValue:accountsInfo
                      forKey:@"accounts"];
    }
    
    // followers
    if (self.followers.count) {
        
        [publicInfo setValue:self.followersUsernames
                      forKey:@"followers"];
    }
    
    // following
    if (self.following.count) {
        
        [publicInfo setValue:self.followingUsernames
                      forKey:@"following"];
    }
    
    
    
    return publicInfo;
}

-(NSDictionary *)allInfo
{
    NSMutableDictionary *allInfo = [[NSMutableDictionary alloc] initWithDictionary:self.publicInfo];
    
    
}

#pragma mark

-(NSArray *)skillsNames
{
    // get the IDs of our skills...
    
    NSMutableArray *skillsNames = [[NSMutableArray alloc] init];
    
    for (Skill *skill in self.skills) {
        
        [skillsNames addObject:skill.name];
        
    }
    
    return skillsNames;
}

-(NSArray *)teamIDs
{
    // get the IDs of the teams the user is a member of...
    
    NSMutableArray *teamIDs = [[NSMutableArray alloc] init];
    
    for (Team *team in self.teams) {
        
        [teamIDs addObject:team.id];
    }
    
    return teamIDs;
}

-(NSArray *)followersUsernames
{
    NSMutableArray *followersUsernames = [[NSMutableArray alloc] init];
    
    for (User *follower in self.followers) {
        
        [followersUsernames addObject:<#(id)#>]
        
    }
    
}

@end
