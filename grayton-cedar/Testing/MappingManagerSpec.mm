#import "MappingManager.h"
#import <RestKit/RestKit.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MappingManagerSpec)

describe(@"MappingManager", ^{
    __block MappingManager *model;

    beforeEach(^{
        NSBundle *testBundle = [NSBundle bundleWithIdentifier:@"org.restkit.RKTestingExampleTests"];
//        [RKTestFixture setFixtureBundle:testBundle];
    });
});

SPEC_END
