#define HC_SHORTHAND

#import <UIKit/UIKit.h>
#import <Cedar-iOS/SpecHelper.h>
#import <OCMock-iPhone/OCMock.h>
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import "RequestHelper.h"

/*
SPEC_BEGIN(FirstTestSpec)
describe(@"FirstTest", ^{
    beforeEach(^{
        NSLog(@"test started");
    });
    afterEach(^{
        NSLog(@"test finished");
    });
    it(@"shouldBeYES", ^{
        NSLog(@"test proceeded");
        assertThatBool(NO, equalToBool(NO));
    });  
});
SPEC_END*/

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"CedarApplicationDelegate");
    [pool release];
    return retVal;
}