//
//  Post+Visibility.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/12/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "Post.h"
#import "SDSVisibility.h"

@interface Post (Visibility) <SDSVisibility>

-(BOOL)isVisibleToUser:(User *)user;

@end
