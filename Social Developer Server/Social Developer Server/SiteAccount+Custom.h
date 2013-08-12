//
//  SiteAccount+Custom.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/11/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SiteAccount.h"

typedef NS_ENUM(NSInteger, SiteAccountType){
    
    OtherAccount = 0,
    TwitterAccount = 1,
    LinkedInAccount,
    FacebookAccount,
    GitHubAccount,
    StackOverflowAccount
    
};

@interface SiteAccount (Custom)

@property (readonly) NSDictionary *publicInfo;

@end
