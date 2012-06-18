//
//  RequestLoader.m
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import "RWRequest.h"
#import "Reachability.h"

@implementation RWRequest

@synthesize urlRequest;
@synthesize attempsToRemain;
@synthesize response;
@synthesize error;
@synthesize userInfo;
@synthesize isFinished = finished;
@synthesize parsingBlock;

- (id) initWithRequest:(NSURLRequest *) aRequest {
    if ((self = [super init])) {
        urlRequest = [aRequest copy];
        receivedData = [[NSMutableData alloc] init];
        observers = [[NSMutableArray alloc] init];
        
        error = nil;
    }
    return self;
}

- (void) dealloc {
    [urlRequest release];
    [receivedData release];
    [urlConnection release];
    [observers release];
    [super dealloc];
}

- (void) main {
    [self notifyObserversWithMethod:@selector(requestWillStartLoading:)];
    
    NSString *host = [[urlRequest URL] host];
    Reachability *reachability = [Reachability reachabilityWithHostName:host];
    if (NotReachable == [reachability currentReachabilityStatus]) {
        [self generateNetworkError];
    }
    else {
        [self notifyObserversWithMethod:@selector(requestDidStartLoading:)];
        [self performRequest];
    }    

    NSLog(@"FINISH LOADING");
}

#pragma mark -
#pragma mark private methods

- (void) performRequest {    
    if (urlConnection) {
        [urlConnection release];
    }
    urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    while (!finished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

- (void) generateNetworkError {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (NotReachable == [reachability currentReachabilityStatus]) {
        error = [NSError errorWithDomain:@"No Internet Connection" code:NSURLErrorNetworkConnectionLost userInfo:nil];
    }
    else {
        error = [NSError errorWithDomain:@"No Host connection" code:NSURLErrorCannotFindHost userInfo:nil];
    }
    
    [self notifyObserversWithMethod:@selector(requestDidFail:)];
    finished = YES;
}

- (void) parseResponseString:(NSString *) responseString {
    JSONDataParser *parser = [[JSONDataParser alloc] initWithJSONString:responseString];
    id parsedResponse = parsingBlock(parser);
    
    if ([parsedResponse isKindOfClass:[NSError class]] || !parsedResponse) {
        error = parsedResponse;
        [self notifyObserversWithMethod:@selector(requestDidFail:)];
    }
    else {
        response = parsedResponse;
        [self notifyObserversWithMethod:@selector(requestDidFinishLoading:)];
    }
    
    [parser release];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"response = %@",responseString);
       
    if (parsingBlock == nil) {
        response = responseString;
        [self notifyObserversWithMethod:@selector(requestDidFinishLoading:)];
    }
    else {
        [self parseResponseString:responseString];
    }
    
    [responseString release];
    finished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError {
    if (--attempsToRemain > 0) {
        [receivedData setData:nil];
        [self performRequest];
    }
    else {
        NSLog(@"Connection failed %@",anError);
        error = [NSError errorWithDomain:@"No Host Connection. Please try again later." 
                                    code:NSURLErrorCannotFindHost 
                                userInfo:nil];
        [self notifyObserversWithMethod:@selector(requestDidFail:)];
        finished = YES;
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

#pragma mark -
#pragma mark public methods

- (void) cancelRequest {
    @synchronized(self) {
        NSLog(@"cancel request = %@",[[urlRequest URL] absoluteString]);
        [urlConnection cancel];
        finished = YES;    
    }
}

#pragma mark -
#pragma mark register observers

- (void) registerObserver:(id<RWRequestDelegate>) observer {
    if (observer && ![observers containsObject:observer]) {
        [observers addObject:observer];
    }
}

- (void) removeObserver:(id<RWRequestDelegate>) observer {
    if (observer && [observers containsObject:observer]) {
        [observers removeObject:observer];
    }
}

- (void) notifyObserversWithMethod:(SEL) selector {
    for (id<RWRequestDelegate> observer in observers) {
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject:self];
        }
    }
}

@end
