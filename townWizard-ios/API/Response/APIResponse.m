//
//  GPAPIResponse.m
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "APIResponse.h"

@implementation APIResponse

+(instancetype)responseWithHTTPResponse:(NSURLResponse *)httpResponse
{
    APIResponse *response = [self new];
    response.HTTPURLResponse = httpResponse;
    return response;
}

@end
