//
//  SDSServer.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RoutingHTTPServer, CDASQLiteDataStore;

@interface SDSServer : NSObject
{
    RoutingHTTPServer *_server;
    
    // Operation queues
    
    NSOperationQueue *_createPostQueue;

}

@property CDASQLiteDataStore *dataStore;

@property BOOL prettyPrintJSON;

@property NSUInteger sessionTokenLength;

@property NSUInteger apiAppSessionTokenLength;

-(NSError *)startWithPort:(NSUInteger)port;

-(void)stop;

@end
