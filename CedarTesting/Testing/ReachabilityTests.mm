#import <UIKit/UIKit.h>
#import <Cedar-iOS/SpecHelper.h>
#import <OCMock-iPhone/OCMock.h>
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import "Reachability.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(Reachability_)

describe(@"Requests", ^{
    it(@"should reach google", ^{
        [Reachability reachabilityWithURL:[NSURL URLWithString:@"http://www.google.com"]] should be_truthy;

    });
    
    it(@"should reach townWizard",^{
        [Reachability reachabilityWithURL:[NSURL URLWithString:@"http://www.townwizard.com"]] should be_truthy;
    });
    
    it(@"should not reach some crap",^{
        [Reachability reachabilityWithURL:[NSURL URLWithString:@"sglhdslvhdslkvhdsklv"]] should_not be_truthy; 
    });
    
});

SPEC_END