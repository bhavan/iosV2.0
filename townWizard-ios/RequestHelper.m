//
//  RequestHelper.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestHelper.h"
#import "AppDelegate.h"


#define REQUEST_TIMEOUT 30
#define API_PATH @"api/partner/"

NSData* PerformURLRequest(NSURLRequest* request) {
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error; 
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&urlResponse 
                                                     error:&error];    
    //  [error release];
    return data;
}

@implementation RequestHelper

+(NSMutableURLRequest*) defaultRequest:(NSString*)apiPath params:(NSMutableDictionary*) paramsDict {
    NSString* formattedRequestString = [self formattedRequestStringWithParams:paramsDict];
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,apiPath,formattedRequestString];
    NSLog(@"call url %@",urlString);
    
    NSURL* requestUrl = [NSURL URLWithString:urlString];    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestUrl 
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:REQUEST_TIMEOUT];
    
    [request setHTTPMethod:@"GET"];
    // [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];  
    return [request autorelease];
}

+(NSURLRequest *)searchRequestUsingCurrentGeoposition {
    NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [paramsDict setObject:appDelegate.latitude forKey:@"lat"];
    [paramsDict setObject:appDelegate.longitude forKey:@"lon"];   
    
    return [self defaultRequest:API_PATH params:paramsDict];
}

+(NSURLRequest *)searchRequest:(NSString *)searchQuery {
    NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithCapacity:1];
   
    if(searchQuery != nil) {
        [paramsDict setObject:searchQuery forKey:@"q"];
    }
    return [self defaultRequest:API_PATH params:paramsDict];
}

+(NSURLRequest *)sectionsWithPartner:(NSString *)partnerId {
    
    NSString *request = [NSString stringWithFormat:@"api/section/partner/%@",partnerId];
    return [self defaultRequest:request params:nil];
}
#pragma mark -
#pragma mark format params

+(NSString*) formattedRequestStringWithParams:(NSDictionary*) params {
	NSMutableString* result = [NSMutableString stringWithCapacity:3];
	
    NSArray* keys = [params allKeys];
	NSInteger keyCount = [keys count];
    if(keyCount >0) {
        [result appendString:@"?"];
    }
	
	for (NSInteger i = 0; i < keyCount; i++) {
		NSString* key = [keys objectAtIndex: i];					 
		[result appendFormat:@"%@=%@", key, [params objectForKey:key]];
		if (i + 1 < keyCount) {
			[result appendString:@"&"];		
        }
    }    
    return result;	
}
@end
