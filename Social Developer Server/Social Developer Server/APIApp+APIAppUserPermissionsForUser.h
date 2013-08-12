//
//  APIApp+APIAppUserPermissionsForUser.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "APIApp.h"
@class APIAppUserPermissions, User;

@interface APIApp (APIAppUserPermissionsForUser)

// checks if the User has given this API App any permissions and returns them
-(APIAppUserPermissions *)permissionsForUser:(User *)user;

@end
