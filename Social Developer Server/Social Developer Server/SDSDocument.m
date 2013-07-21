//
//  SDSDocument.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 7/21/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "SDSDocument.h"
#import "SDSDataStore.h"

@implementation SDSDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SDSDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

-(BOOL)readFromURL:(NSURL *)url
            ofType:(NSString *)typeName
             error:(NSError *__autoreleasing *)outError
{
    _dataStore = [[SDSDataStore alloc] init];
    _dataStore.packageURL = url;
    
    
    
}

-(BOOL)writeToURL:(NSURL *)url
           ofType:(NSString *)typeName
            error:(NSError *__autoreleasing *)outError
{
    
    
}


@end
