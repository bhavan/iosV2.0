//
//  NSDate+Helpers.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSDate *)dateWithoutTime
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit 
                                                          | NSMonthCalendarUnit 
                                                          | NSDayCalendarUnit ) 
                                                fromDate:self];
	
	return [calendar dateFromComponents:components];
}

- (NSDate *) dateByAddingDays:(NSInteger) days months:(NSInteger) months years:(NSInteger) years
{
	NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
	dateComponents.day = days;
	dateComponents.month = months;
	dateComponents.year = years;
	NSDate *result = [[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                   toDate:self
                                                                  options:0] retain];
    return result;
}

- (NSDate *) dateByAddingDays:(NSInteger) days
{
    return [self dateByAddingDays:days months:0 years:0];
}

- (NSDate *) dateByAddingMonths:(NSInteger) months
{
    return [self dateByAddingDays:0 months:months years:0];
}

- (NSDate *) dateByAddingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:years];
}

- (NSDate *) monthStartDate 
{
    NSDate *monthStartDate = nil;
	[[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                    startDate:&monthStartDate 
                                     interval:NULL
                                      forDate:self];

	return monthStartDate;
}

- (NSUInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit 
                                              inUnit:NSMonthCalendarUnit 
                                             forDate:self].length;
}

- (NSUInteger) weekday
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    [gregorian release];
    return [weekdayComponents weekday];
}

- (NSString *) dateStringWithFormat:(NSString *) format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
	NSString *result = [formatter stringFromDate:self];
    [formatter release];
	return result;
}

- (NSInteger) daysSinceDate:(NSDate *) date
{
    return [self timeIntervalSinceDate:date] / (60 * 60 * 24);
}

@end
