//
//  JSONDataParser.m
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import "JSONDataParser.h"
#import "SBJsonParser.h"

@implementation JSONDataParser

@synthesize jsonString;
@synthesize error;

#pragma mark -
#pragma mark life cycle

- (id) initWithJSONString:(NSString *) theJsonString {
    if (self == [super init]) {
        jsonString = [theJsonString copy];
        [self parseJsonString];
    }
    return self;
}

- (void) dealloc {
    [jsonString release];
    [parsedJsonString release];
    [super dealloc];
}

#pragma mark -
#pragma mark parse response 

- (void) parseJsonString {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    parsedJsonString = [[parser objectWithString:jsonString] retain];
    [parser release];
    
    if (![parsedJsonString isKindOfClass:[NSDictionary class]]) {
        [parsedJsonString release];
        parsedJsonString = nil;
    }
    
    if (parsedJsonString == nil) {
        [self generateInvalidResponseError];
    }
}

- (void) generateInvalidResponseError {
    if (jsonString == nil || [jsonString isEqualToString:@""]) {
        error = [NSError errorWithDomain:@"Empty server response" code:NSURLErrorCannotParseResponse userInfo:nil];
    }
    else {
        error = [NSError errorWithDomain:@"Wrong response format" code:NSURLErrorBadServerResponse userInfo:nil];
    }
}

- (void) generateResponseError {
    if ([parsedJsonString objectForKey:@"error"] != nil) {
        error = [NSError errorWithDomain:[parsedJsonString stringForKey:@"error"]
                                    code:NSURLErrorDataNotAllowed
                                userInfo:nil];
    }
    else {
        if ([parsedJsonString objectForKey:@"errors"] != nil) {
            NSArray *errors = [parsedJsonString objectForKey:@"errors"];
            NSMutableString *errorMessage = [NSMutableString string];
            for (NSString *errorString in errors) {
                [errorMessage appendFormat:@"%@.",errorString];
                if ([errors lastObject] != errorString) {
                    [errorMessage appendString:@" "];
                }
            }
        }
        else {
            error = [NSError errorWithDomain:@"Unknown server error" code:NSURLErrorDataNotAllowed userInfo:nil];
        }
    }
}

- (id) getResponseData {
    if (error == nil) {
        if ([parsedJsonString objectForKey:@"data"] != nil) {
            return [parsedJsonString objectForKey:@"data"];
        }
        else {
            error = [NSError errorWithDomain:@"No data in response" code:NSURLErrorDataNotAllowed userInfo:nil];
        }
    }
    return nil;
}

- (BOOL) isRequestSuccess {
    if (error == nil) {
        return [parsedJsonString boolForKey:@"status"];
    }
    return NO;
}

#pragma mark -
#pragma mark parser methods

@end
