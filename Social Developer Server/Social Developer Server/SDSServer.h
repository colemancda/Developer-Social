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

}

@property CDASQLiteDataStore *dataStore;

-(NSError *)startWithPort:(NSUInteger)port;

-(void)setupRoutes;

@end
