//
//  SDSServer.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/4/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RoutingHTTPServer;

@interface SDSServer : NSObject
{
    RoutingHTTPServer *_server;

}

-(NSError *)startWithPort:(NSUInteger)port;

-(void)setupRoutes;

@end
