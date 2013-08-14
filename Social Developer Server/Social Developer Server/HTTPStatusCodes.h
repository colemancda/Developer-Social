//
//  HTTPStatusCodes.h
//  Social Developer Server
//
//  Created by Alsey Coleman Miller on 8/13/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#ifndef Social_Developer_Server_HTTPStatusCodes_h
#define Social_Developer_Server_HTTPStatusCodes_h

typedef NS_ENUM (NSInteger, HTTPStatusCode) {
    
    OKStatusCode = 200,
    
    BadRequestStatusCode = 400,
    UnauthorizedStatusCode, // not logged in
    PaymentRequiredStatusCode,
    ForbiddenStatusCode, // item is invisible to user or api app
    NotFoundStatusCode, // item doesnt exist
    MethodNotAllowedStatusCode,
    ConflictStatusCode = 409, // user already exists
    
    InternalServerErrorStatusCode = 500
    
};

#endif
