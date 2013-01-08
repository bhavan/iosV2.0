//
//  NSDate+Formatting.h
//  CommandCenter-iPad
//
//  Created by Evgeniy Kirpichenko on 8/1/12.
//  Copyright (c) 2012 Evgeniy Kirpichenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatting)

+ (NSString *)stringFromPeriod:(NSDate *)start end:(NSDate *)end;
+ (NSDate *) dateFromString:(NSString *) dateString dateFormat:(NSString *) dateFormat;
+ (NSDate *) dateFromUTCString:(NSString *) dateString dateFormat:(NSString *) dateFormat;

+ (NSString *) stringFromDate:(NSDate *) date dateFormat:(NSString *) dateFormat;
+ (NSString *) utcStringFromDate:(NSDate *) date dateFormat:(NSString *) dateFormat;
+ (NSString *) stringFromDate:(NSDate *) date
                   dateFormat:(NSString *) dateFormat
             localeIdentifier:(NSString *) localeIdentifier;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (NSDate *)dateAtEndingOfDayForDate:(NSDate *)inputDate;
+ (BOOL)isDate:(NSDate *)date inPeriodWithStart:(NSDate *)start end:(NSDate *)end;


@end
