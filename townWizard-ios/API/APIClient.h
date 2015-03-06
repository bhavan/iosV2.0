//
//  APIClient.h
//
//  Created by Denys Telezhkin on 15.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//
#import "APIRequest.h"
#import "APIResponse.h"
#import "ParsedError.h"

typedef void(^APISuccessBlock)(id result, APIResponse * response);
typedef void(^APIFailureBlock)(ParsedError * error);

@interface APIClient : NSObject

+(instancetype)sharedClient;

@property (nonatomic, strong) NSURL * baseURL;

/**
 This method is required to call before sharedClient method.
 */
+(void)setupWithBaseURL:(NSURL *)baseAPIURL;

-(NSURLSessionTask *)performRequest:(APIRequest *)request
                            success:(APISuccessBlock)success
                            failure:(APIFailureBlock)failure;

@end
