#import <UIKit/UIKit.h>
#import <Cedar-iOS/SpecHelper.h>
#import <OCMock-iPhone/OCMock.h>
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import "RequestHelper.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(Request_Helper)

describe(@"formatted request", ^{
    it(@"should contain all parameters", ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
        NSString *first = @"first";
        NSString *second = @"second";
        NSString *third = @"third";
        
        NSMutableDictionary* paramsDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [paramsDict setObject:first forKey:first];
        [paramsDict setObject:second forKey:second];
        [paramsDict setObject:third forKey:third];
        NSString *resultParameters = [RequestHelper formattedRequestStringWithParams:paramsDict];
        
        NSRange firstRange =[resultParameters rangeOfString:[NSString stringWithFormat:@"first=first"] 
                                                    options:NSCaseInsensitiveSearch];
        NSRange secondRange =[resultParameters rangeOfString:[NSString stringWithFormat:@"second=second"] 
                                                     options:NSCaseInsensitiveSearch];
        NSRange thirdRange =[resultParameters rangeOfString:[NSString stringWithFormat:@"third=third"] 
                                                    options:NSCaseInsensitiveSearch];
        
        firstRange.location should be_greater_than(0);
        secondRange.location should be_greater_than(0);
        thirdRange.location should be_greater_than(0);

        [params release];
        
    });
    
    it(@"should contain query",^{
        NSString *query = @"testQuery";
        NSURLRequest *searchRequest = [RequestHelper searchRequest:query];
        searchRequest should_not be_nil;
        
        NSString *urlString = [[searchRequest URL] absoluteString];
        NSRange textRange;
        textRange =[[urlString lowercaseString] rangeOfString:[query lowercaseString]];
        
        textRange.location should be_greater_than(0);
    }); 
});
SPEC_END
