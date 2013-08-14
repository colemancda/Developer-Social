//
//  RouteResponse+IPAddress.m
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "RouteResponse+IPAddress.h"
#import "RoutingConnection.h"
#import "GCDAsyncSocket.h"

@implementation HTTPConnection (Socket)

-(GCDAsyncSocket *)socket
{
    return asyncSocket;
}

@end

@implementation RouteResponse (IPAddress)

-(NSString *)ipAddress
{
    return self.connection.socket.connectedHost;
}

@end
