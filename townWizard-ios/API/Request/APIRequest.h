//
//  GPAPIRequest.h
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelFactory.h"

@interface APIRequest : NSObject

+(instancetype)requestWithPath:(NSString *)path;

/**
 Default - GET
 */
@property (nonatomic, strong) NSString * method;

/**
 Default - nil.
 */
@property (nonatomic, strong) ModelFactory * modelFactory;

@property (nonatomic, strong) NSString * path;

/**
 Default - empty
 */
@property (nonatomic, strong) NSDictionary * parameters;

/**
 Default - NO
 */
@property (nonatomic, assign) BOOL requiresXAccessToken;

/**
 Request serializer class. Default - GPRequestSerializer
 */
@property (nonatomic, assign) Class requestSerializerClass;

-(NSMutableURLRequest *)URLRequestWithBaseURL:(NSURL *)baseURL;

@end
