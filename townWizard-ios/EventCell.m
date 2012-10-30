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

    [super dealloc];
}

#pragma mark -
#pragma mark cell updating

- (void) updateWithEvent:(Event *) event
{
    if (![[self event] isEqual:event]) {
        [self setEvent:event];
        [eventTitle setText:[event title]];
        [eventLocation setText:[[event location] address]];
        [eventTime setText:[self eventDateString]];
        
//        Maybe it's not necessary
//        [self layoutSubviews];
    }
}

- (NSString *) eventDateString
{
    NSString *startTimeString = [NSDate stringFromDate:[[self event] startTime] dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    NSString *endTimeString = [NSDate stringFromDate:[[self event] endTime] dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    return [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    [eventTitle sizeToFit];
    
    CGRect locationFrame = [eventLocation frame];
    locationFrame.origin.y = CGRectGetMaxY([eventTitle frame]);
    [eventLocation setFrame:locationFrame];
}

@end
