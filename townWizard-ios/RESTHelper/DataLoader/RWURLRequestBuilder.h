//
//  RequestHelper.h
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWURLRequestBuilder : NSObject {
    NSString *hostName;
    NSTimeInterval requestTimeout;
}

- (id) initWithHostName:(NSString *) theHostName;

- (NSURLRequest *) buildGetRequest;
- (NSURLRequest *) buildDeleteRequest;
- (NSURLRequest *) buildPostRequest;
- (NSURLRequest *) buildMultipartPostRequest;

@property (nonatomic,retain) NSString *apiPath;
@property (nonatomic,retain) NSDictionary *headerParams;
@property (nonatomic,retain) NSDictionary *urlParams;
@property (nonatomic,retain) NSDictionary *bodyParams;
@property (nonatomic,retain) NSDictionary *bodyBinaryParams;
@property (nonatomic,assign) NSTimeInterval requestTimeout;

@end
