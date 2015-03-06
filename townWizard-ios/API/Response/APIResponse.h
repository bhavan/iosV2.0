//
//  GPAPIResponse.h
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIResponse : NSObject

+(instancetype)responseWithHTTPResponse:(NSURLResponse *)response;

@property (nonatomic, strong) NSURLResponse *HTTPURLResponse;

@end
