//
//  RequestHelper.m
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import "RWURLRequestBuilder.h"

#define POST_REQUEST_SEPARATOR  @"---------------------------14737809831466499882746641449"
#define DEFAULT_REQUEST_TIMEOUT 15.

@implementation RWURLRequestBuilder

@synthesize requestTimeout;
@synthesize apiPath;

@synthesize headerParams;
@synthesize urlParams;
@synthesize bodyParams;
@synthesize bodyBinaryParams;

#pragma mark -
#pragma mark life cycle

- (id) initWithHostName:(NSString *) theHostName {
    if ((self = [super init])) {
        hostName = [theHostName copy];
        requestTimeout = DEFAULT_REQUEST_TIMEOUT;
    }
    return self;
}

- (void) dealloc {
    [hostName release];
    [self setApiPath:nil];
    [self setHeaderParams:nil];
    [self setUrlParams:nil];
    [self setBodyParams:nil];
    [self setBodyBinaryParams:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark helpers

- (NSMutableURLRequest *) buildMutableRequest {
    NSURL *requestUrl = [self buildURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                       timeoutInterval:requestTimeout];
    for (NSString *key in [headerParams allKeys]) {
        [request addValue:[headerParams objectForKey:key] forHTTPHeaderField:key];
    }
    return request;
}

- (NSURL *) buildURL {
    NSString *formattedURLParams = [self formatParams:urlParams]; 
    NSString *fullURL = [NSString stringWithFormat:@"http://%@%@?%@",hostName,apiPath,formattedURLParams];
    return [NSURL URLWithString:[fullURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) formatParams:(NSDictionary *) params {
	NSMutableString *result = [NSMutableString stringWithCapacity:0];
	
    NSArray *keys = [params allKeys];
	NSInteger keyCount = [keys count];
	
	for (NSInteger i = 0; i < keyCount; i++) {
		NSString *key = [keys objectAtIndex: i];					 
		[result appendFormat:@"%@=%@", key, [params objectForKey:key]];
		if (i + 1 < keyCount) 
			[result appendString:@"&"];		
	}
    
    return result;	
}

#pragma mark -
#pragma mark creating requests

- (NSURLRequest *) buildGetRequest {
    NSMutableURLRequest *request = [self buildMutableRequest];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSURLRequest *) buildDeleteRequest {
    NSMutableURLRequest *request = [self buildMutableRequest];
    [request setHTTPMethod:@"DELETE"];
    return request;
}

- (NSURLRequest *) buildPostRequest {
    NSMutableURLRequest *request = [self buildMutableRequest];
    [request setHTTPMethod:@"POST"];
    
    NSString *formattedBodyParams = [self formatParams:bodyParams];
    [request setHTTPBody:[formattedBodyParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSURLRequest *) buildMultipartPostRequest { 
    NSMutableURLRequest *request = [self buildMutableRequest];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",POST_REQUEST_SEPARATOR];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[self buildMultipartPostRequestBody]];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

#pragma mark -
#pragma mark multipart post request helpers

- (NSData *) buildMultipartPostRequestBody {
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    [bodyData appendData:[self buildMultipartPostRequestBodyParams]];
    [bodyData appendData:[self buildMultipartPostRequestBodyBinaryParams]];
    
    NSString *bodyCloseSeparator = [NSString stringWithFormat:@"\r\n--%@--\r\n",POST_REQUEST_SEPARATOR];
    [bodyData appendData:[bodyCloseSeparator dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [bodyData autorelease];
}

- (NSData *) buildMultipartPostRequestBodyParams {
    NSMutableData *bodyParamsData = [NSMutableData data];
    NSData *separator = [[self multipartDataSeparator] dataUsingEncoding:NSUTF8StringEncoding];
    for (NSString *key in [bodyParams allKeys]) {
        NSData *currentParamData = [self dataForPostingParam:key withValue:[bodyParams objectForKey:key]];
        [bodyParamsData appendData:separator];        
        [bodyParamsData appendData:currentParamData];
    }
    return bodyParamsData;
}

- (NSData *) buildMultipartPostRequestBodyBinaryParams {
    NSMutableData *bodyParamsData = [NSMutableData data];
    NSData *separator = [[self multipartDataSeparator] dataUsingEncoding:NSUTF8StringEncoding];
    for (NSString *key in [bodyBinaryParams allKeys]) {
        NSData *currentParamData = [self createDataForPostingBinaryParam:key data:[bodyBinaryParams objectForKey:key]];
        [bodyParamsData appendData:separator];
        [bodyParamsData appendData:currentParamData];
        [currentParamData release];
    }
    return bodyParamsData;
}

- (NSString *) multipartDataSeparator {
   return [NSString stringWithFormat:@"\r\n--%@\r\n",POST_REQUEST_SEPARATOR];
}

- (NSData *) dataForPostingParam:(NSString *) paramKey withValue:(NSString *) value {
    NSMutableString *postParamString = [[NSMutableString alloc] init];
	[postParamString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",paramKey];
    
    NSString *valueString = [value isKindOfClass:[NSString class]] ? value : [(id)value stringValue];
    [postParamString appendString:valueString];
    
    NSData *paramData = [postParamString dataUsingEncoding:NSUTF8StringEncoding];
    [postParamString release];
    
    return paramData;
}

- (NSData *) createDataForPostingBinaryParam:(NSString *) paramKey data:(NSData *) data {
    NSMutableData* newData = [[NSMutableData alloc] init];
    
    NSMutableString *separatorString = [[NSMutableString alloc] init];
    [separatorString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"itemPhoto.jpg\"\r\n",paramKey];
    [separatorString appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    [newData appendData:[separatorString dataUsingEncoding:NSUTF8StringEncoding]];
    [newData appendData:data];
    
    [separatorString release];
    return newData;
}

@end
