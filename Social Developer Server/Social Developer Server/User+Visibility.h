//
//  User+Visibility.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "User.h"

@interface User (Visibility)

-(BOOL)isVisibleForUser:(User *)user apiApp:()

@end
