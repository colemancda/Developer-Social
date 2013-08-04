//
//  SDSDataStore.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CompletionBlock.h"
@class CDASQLiteDataStore;

@interface SDSDataStore : NSObject
{
    CDASQLiteDataStore *_sqliteDataStore;
}

#pragma mark - Store Actions

-(void)save:(completionBlock)completionBlock;

#pragma mark - Generated URLs

@property (readonly) NSString *appSupportDirectory;

@property (readonly) NSString *sqliteFilePath;

@property (readonly) NSString *countPlistFilePath;

#pragma mark - Saved Count

@property (readonly) NSUInteger lastTeamID;

@property (readonly) NSUInteger lastImageID;

@property (readonly) NSUInteger lastPostID;

@property (readonly) NSUInteger lastLinkID;

#pragma mark 


@end
