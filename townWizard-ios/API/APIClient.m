//
//  APIClient.m
//
//  Created by Denys Telezhkin on 15.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "APIClient.h"
#import "ABMultitonProtocol.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"
#import "APIResponse.h"

@interface APIClient() <ABMultitonProtocol>
@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@end

@implementation APIClient

+(instancetype)sharedClient
{
    NSAssert([[self shared] baseURL] != nil, @"setupWithBaseURL must be called before sharedClient");
    
    return [self shared];
}

+(void)setupWithBaseURL:(NSURL *)baseAPIURL
{
    APIClient * client = [self shared];
    client.baseURL = baseAPIURL;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    client.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:client.baseURL];
    client.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
}

-(NSURLSessionTask *)performRequest:(APIRequest *)request success:(APISuccessBlock)success failure:(APIFailureBlock)failure
{
    void (^completionHandler)(NSURLResponse *, id, NSError *) = nil;
    completionHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {
         if (error)
         {
             if (failure)
             {
                 failure([ParsedError parsedErrorWithError:error
                                                    fromJSON:responseObject]);
             }
         }
         else {
             if (success) {
                 APIResponse *apiResponse = [APIResponse responseWithHTTPResponse:response];
                 success([request.modelFactory fromJSONObject:responseObject],apiResponse);
             }
         }
     };
    NSURLSessionTask * task = [self.sessionManager dataTaskWithRequest:request.URLRequest
                                                     completionHandler:completionHandler];
    [task resume];
    
    return task;
}

@end
