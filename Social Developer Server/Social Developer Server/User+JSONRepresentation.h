//
//  User+JSONRepresentation.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"
#import "SDSJSON.h"

@interface User (JSONRepresentation) <SDSJSON>

@property (readonly) NSArray *teamIDs;

@property (readonly) NSArray *followersUsernames;

@property (readonly) NSArray *followingUsernames;


@end
