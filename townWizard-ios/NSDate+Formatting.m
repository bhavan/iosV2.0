//
//  NSDate+Formatting.m
//  CommandCenter-iPad
//
//  Created by Evgeniy Kirpichenko on 8/1/12.
//  Copyright (c) 2012 Evgeniy Kirpichenko. All rights reserved.
//

#import "NSDate+Formatting.h"
#import "NSDateFormatter+Extensions.h"

@implementation NSDate (Formatting)

+ (NSDate *) dateFromString:(NSString *) dateString dateFormat:(NSString *) dateFormat {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithDateFormat:dateFormat];
    return [formatter dateFromString:dateString];
}

+ (NSDate *) dateFromUTCString:(NSString *) dateString dateFormat:(NSString *) dateFormat {
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithDateFormat:dateFormat
                                                                     timezone:utcTimeZone];
    return [formatter dateFromString:dateString];
}

+ (NSString *) stringFromDate:(NSDate *) date dateFormat:(NSString *) dateFormat {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithDateFormat:dateFormat];    
    return [formatter stringFromDate:date];
}

+ (NSString *) utcStringFromDate:(NSDate *) date dateFormat:(NSString *) dateFormat
{
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithDateFormat:dateFormat
                                                                     timezone:utcTimeZone];
    return [formatter stringFromDate:date];
}

+ (NSString *) stringFromDate:(NSDate *) date
                   dateFormat:(NSString *) dateFormat
             localeIdentifier:(NSString *) localeIdentifier;
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithDateFormat:dateFormat];
    [formatter setLocale:locale];
    [locale release];
    return [formatter stringFromDate:date]; 
}


+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}



@end
