//
//  GPAPIRequest.m
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "APIRequest.h"
#import "RequestSerializer.h"
#import "APIClient.h"

@implementation APIRequest

-(instancetype)init
{
    if (self = [super init])
    {
        _method = @"GET";
        _requiresAuthentication = NO;
        _requestSerializerClass = [RequestSerializer class];
        _parameters = @{};
    }
    return self;
}

+(instancetype)requestWithPath:(NSString *)path
{
    APIRequest * request = [self new];
    request.path = path;
    return request;
}

-(void)setRequestSerializerClass:(Class)requestSerializerClass
{
    NSParameterAssert([requestSerializerClass isSubclassOfClass:[RequestSerializer class]]);
    
    _requestSerializerClass = requestSerializerClass;
}

-(NSMutableURLRequest *)URLRequest
{
    APIClient * client = [APIClient sharedClient];
    RequestSerializer * requestSerializer = [self.requestSerializerClass serializer];
    
    NSString * urlString = [[NSURL URLWithString:self.path relativeToURL:client.baseURL] absoluteString];
    
    return [requestSerializer requestWithMethod:self.method
                                      URLString:urlString
                                     parameters:self.parameters
                                          error:nil];
}

@end
