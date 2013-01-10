//
//  EventsControllerView.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import "EventsView.h"
#import "UIButton+Extensions.h"

@implementation EventsView

@synthesize calendarButton;
@synthesize eventsTypeButton;
@synthesize addEventButton;
@synthesize tableFooter;
@synthesize tableHeader;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setButtonsBackground];
    [self setBackgroundColorForTableSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) dealloc
{
    [calendarButton release];
    [eventsTypeButton release];
    [addEventButton release];
    [tableHeader release];
    [tableFooter release];
    [super dealloc];
}

#pragma mark -
#pragma mark prepare buttons

- (void) setButtonsBackground
{    
    [calendarButton setButtonBackgroundImage];
    [eventsTypeButton setButtonBackgroundImage];
    [addEventButton setButtonBackgroundImage];
}

#pragma mark -
#pragma mark prepare table subviews

- (void) setBackgroundColorForTableSubviews
{
    UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"events_pattern_bg"]];
    [tableHeader setBackgroundColor:backgroundColor];
    [tableFooter setBackgroundColor:backgroundColor];
}

@end
