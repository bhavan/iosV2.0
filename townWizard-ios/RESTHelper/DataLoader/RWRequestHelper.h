//
//  RequestHelper.h
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWRequest.h"

@class RWURLRequestBuilder;

@interface RWRequestHelper : NSObject {
    RWURLRequestBuilder *requestBuilder;
}

- (void) performRequest:(RWRequest *) aRequest withObserver:(id<RWRequestDelegate>) observer;

- (RWRequest *) sectionsRequestForPartnerWithId:(NSString *) partnerId;

@end
