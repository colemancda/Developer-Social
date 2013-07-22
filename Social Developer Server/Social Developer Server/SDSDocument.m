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
        
        NSLog(@"Creating new SDSDocument");
        
        _dataStore = [[SDSDataStore alloc] init];
        
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
    
    // disable undo manager
    self.undoManager = nil;
    
    // UI
    [self refreshNumberOfUsers];
    
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

-(BOOL)readFromURL:(NSURL *)url
            ofType:(NSString *)typeName
             error:(NSError *__autoreleasing *)outError
{
    _dataStore.packageURL = url;
    
    NSError *error = [_dataStore open];
    
    if (error) {
        *outError = error;
        return NO;
    }
    
    return YES;
}

-(BOOL)writeToURL:(NSURL *)url
           ofType:(NSString *)typeName
            error:(NSError *__autoreleasing *)outError
{
    _dataStore.packageURL = url;
    
    // create folder if none exists
    BOOL foundFolder;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:url.filePathURL.absoluteString
                                                           isDirectory:&foundFolder];
    if (!fileExists || !foundFolder) {
        
        NSError *createFolderError;
        [[NSFileManager defaultManager] createDirectoryAtURL:url
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&createFolderError];
        if (createFolderError) {
            *outError = createFolderError;
            return NO;
        }
    }
    
    NSError *error = [_dataStore save];
    
    if (error) {
        *outError = error;
        return NO;
    }
    
    return YES;
}

#pragma mark - UI Fetch Values

-(void)refreshNumberOfUsers
{
    // load statistics
    [_dataStore numberOfUsers:^(NSUInteger numberOfUsers) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.numberOfUsersTextField.integerValue = numberOfUsers;
            
        }];
    }];
    
}


@end
