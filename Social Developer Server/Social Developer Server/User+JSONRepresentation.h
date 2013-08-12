//
//  User+JSONRepresentation.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"
#import "RESTfulJSONRepresentation.h"

@interface User (JSONRepresentation) <RESTfulJSONRepresentation>

@property (readonly) NSArray *skillsNames;

@property (readonly) NSArray *teamIDs;

@property (readonly) NSArray *followersUsernames;

@property (readonly) NSArray *followingUsernames;


@end
