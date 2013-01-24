//
//  Event.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "Event.h"
#import "NSDate+Formatting.h"

#define EVENT_SORT_DATE_FORMAT @"yyyy-MM-dd H:mm:ss"
#define EVENT_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define EVENT_TIME_FROMAT @"h:mma"
#define DAY_START @"12:00AM"
#define DAY_END @"11:59PM"
#define ALL_DAY_PERIOD @"12:00AM-11:59PM"

@implementation Event

- (NSString *) eventDateString
{
    NSDate *start = [NSDate dateFromString:self.startTime dateFormat:EVENT_DATE_FORMAT];
    NSDate *end = [NSDate dateFromString:self.endTime dateFormat:EVENT_DATE_FORMAT];
    
    NSString *startTimeString = [NSDate stringFromDate:start
                                            dateFormat:EVENT_TIME_FROMAT
                                      localeIdentifier:@"en_US"];
    NSString *endTimeString = [NSDate stringFromDate:end
                                          dateFormat:EVENT_TIME_FROMAT
                                    localeIdentifier:@"en_US"];
    NSString *period = [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
    NSString *allDayPeriod = [NSString stringWithFormat:@"%@-%@",DAY_START, DAY_END];
    if([period isEqualToString:allDayPeriod])
    {
        return @"ALL DAY EVENT";
    }
    else if ([endTimeString isEqualToString:DAY_END] && ![startTimeString isEqualToString:DAY_START])
    {
        return startTimeString;
    }
    return [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
}

- (NSComparisonResult)compareByDate:(Event *)event
{
    NSDate *start = [NSDate dateFromString:self.startTime dateFormat:EVENT_SORT_DATE_FORMAT];
     NSDate *startOther = [NSDate dateFromString:event.startTime dateFormat:EVENT_SORT_DATE_FORMAT];
    NSComparisonResult res = [start compare:startOther];
    return res;
    
}

@end
