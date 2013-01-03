//
//  EventCell.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventCell.h"
#import "NSDate+Formatting.h"

#define EVENT_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define EVENT_TIME_FROMAT @"h:mma"
#define ALL_DAY_PERIOD @"12:00AM-11:59PM"

@interface EventCell ()
@property (nonatomic, retain, readwrite) Event *event;
@end

@implementation EventCell

#pragma mark -
#pragma mark life cycle

- (void) dealloc
{
    [eventTitle release];
    [eventLocation release];
    [eventTime release];

    [eventCategory release];
    [super dealloc];
}

#pragma mark -
#pragma mark cell updating

- (void) updateWithEvent:(Event *) event
{
    if (![[self event] isEqual:event])
    {
        [self setEvent:event];
        [eventTitle setText:[event title]];
        [eventLocation setText:[[event location] name]];
        [eventTime setText:[[self eventDateString] uppercaseString]];
        [eventCategory setText:[self.event.categoryName uppercaseString]];
    }
}

- (NSString *) eventDateString
{
    NSDate *start = [NSDate dateFromString:self.event.startTime dateFormat:EVENT_DATE_FORMAT];
    NSDate *end = [NSDate dateFromString:self.event.endTime dateFormat:EVENT_DATE_FORMAT];
     
    NSString *startTimeString = [NSDate stringFromDate:start dateFormat:EVENT_TIME_FROMAT localeIdentifier:@"en_US"];
    NSString *endTimeString = [NSDate stringFromDate:end dateFormat:EVENT_TIME_FROMAT localeIdentifier:@"en_US"];
    NSString *period = [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
    if([period isEqualToString:ALL_DAY_PERIOD])
    {
        return @"ALL DAY EVENT";
    }
    return [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
}


@end
