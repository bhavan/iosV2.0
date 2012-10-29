//
//  NSDateFormatter+Extensions.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/26/12.
//
//

#import "NSDateFormatter+Extensions.h"

@implementation NSDateFormatter (Extensions)

+ (NSDateFormatter *) dateFormatter
{
    return [[NSDateFormatter new] autorelease];
}

+ (NSDateFormatter *) dateFormatterWithDateFormat:(NSString *) dateFormat
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:dateFormat];
    return dateFormatter;
}

+ (NSDateFormatter *) dateFormatterWithDateFormat:(NSString *) dateFormat timezone:(NSTimeZone *) zone
{
    NSDateFormatter *dateFormatter = [self dateFormatterWithDateFormat:dateFormat];
    [dateFormatter setTimeZone:zone];
    return dateFormatter;
}

@end
