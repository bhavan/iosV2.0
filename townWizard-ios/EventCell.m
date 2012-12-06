//
//  EventCell.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventCell.h"
#import "NSDate+Formatting.h"

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
    if (![[self event] isEqual:event]) {
        [self setEvent:event];
        [eventTitle setText:[event title]];
        [eventLocation setText:[[event location] name]];
        [eventTime setText:[[self eventDateString] uppercaseString]];
        [eventCategory setText:[self.event.categoryName uppercaseString]];
        
//        Maybe it's not necessary
//        [self layoutSubviews];
    }
}

- (NSString *) eventDateString
{
    NSDate *start = [NSDate dateFromString:self.event.startTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:self.event.endTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
     
    NSString *startTimeString = [NSDate stringFromDate:start dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    NSString *endTimeString = [NSDate stringFromDate:end dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    return [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    [eventTitle sizeToFit];
    
    CGRect locationFrame = [eventLocation frame];
    locationFrame.origin.y = CGRectGetMaxY([eventTitle frame])-5;
    [eventLocation setFrame:locationFrame];
}

@end
