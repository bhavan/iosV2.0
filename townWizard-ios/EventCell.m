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

@synthesize eventTitle;
@synthesize eventLocation;
@synthesize eventTime;
@synthesize eventCategory;


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
    if (event && (!self.event || ![self.event isEqual:event]))
    {
        [self setEvent:event];
        [eventTitle setText:[event title]];
        [eventLocation setText:[[event location] name]];
        [eventTime setText:[[event eventDateString] uppercaseString]];
        [eventCategory setText:[self.event.categoryName uppercaseString]];
    }
}




@end
