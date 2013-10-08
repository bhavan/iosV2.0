//
//  GoogleAnalyticsEvent.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/8/13.
//
//

#import "GoogleAnalyticsEvent.h"

#import "RequestHelper.h"
#import "GAI.h"

@implementation GoogleAnalyticsEvent

#pragma mark - life cycle

- (void)dealloc {
    [self setEventName:nil];
    [self setEventDescription:nil];
    
    [super dealloc];
}

#pragma mark - public methods

- (void)send {
    Partner *partner = [[RequestHelper sharedInstance] currentPartner];
    NSString *cityName = [[[partner locations] firstObject] city];
    
    if ([cityName length]) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker trackEventWithCategory:[NSString stringWithFormat:@"%@:",cityName]
                             withAction:[self eventName]
                              withLabel:[self eventDescription]
                              withValue:nil];
    }
}

@end
