//
//  RequestHelper.m
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import "RWRequestHelper.h"
#import "RWURLRequestBuilder.h"

static NSOperationQueue *operationQueue = nil;

@implementation RWRequestHelper

#pragma mark -
#pragma mark life cycle

- (id) init {
    if (self = [super init]) {
        requestBuilder = [[RWURLRequestBuilder alloc] initWithHostName:@"container.mlsdev.com"];
    }
    return self;
}

- (NSOperationQueue *) operationQueue {
    if (!operationQueue) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}

- (void) dealloc {
    [requestBuilder release];
    [super dealloc];
}

#pragma mark -
#pragma mark perform requests

- (void) performRequest:(RWRequest *) aRequest withObserver:(id<RWRequestDelegate>) observer {
    //just register new observer if current request is in queue
    for (RWRequest *request in [[self operationQueue] operations]) {
        if ([request isKindOfClass:[RWRequest class]]) {
            if ([[request urlRequest] isEqual:[aRequest urlRequest]]) {
                [request registerObserver:observer];
                return;
            }
        }
    }
    
    //else add new operation into queue
    [aRequest registerObserver:observer];
    [operationQueue addOperation:aRequest];
}

#pragma mark -
#pragma mark loading methods

- (RWRequest *) partnerDetailsRequest:(NSString *) partnerId {
    NSString *apiPath = [NSString stringWithFormat:@"/api/partner/%@",partnerId];
    [requestBuilder setApiPath:apiPath];
    
    RWRequest *request = [[RWRequest alloc] initWithRequest:[requestBuilder buildGetRequest]];
    [request setParsingBlock:^(JSONDataParser *parser){
        return [parser getResponseData];
    }];
    [request setUserInfo:@"partnerDetails"];
    return [request autorelease];
}

- (RWRequest *) sectionsRequestForPartnerWithId:(NSString *) partnerId {
    NSString *apiPath = [NSString stringWithFormat:@"/api/section/partner/%@",partnerId];
    [requestBuilder setApiPath:apiPath];
    
    RWRequest *request = [[RWRequest alloc] initWithRequest:[requestBuilder buildGetRequest]];
    [request setParsingBlock:^(JSONDataParser *parser){
        return [parser getResponseData];
    }];
    [request setUserInfo:@"sectionsRequest"];
    return [request autorelease];
}



@end
