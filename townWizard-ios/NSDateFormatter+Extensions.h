//
//  NSDateFormatter+Extensions.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/26/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extensions)
+ (NSDateFormatter *) dateFormatter;
+ (NSDateFormatter *) dateFormatterWithDateFormat:(NSString *) dateFormat;
+ (NSDateFormatter *) dateFormatterWithDateFormat:(NSString *) dateFormat timezone:(NSTimeZone *) zone;
@end
