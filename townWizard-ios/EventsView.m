//
//  EventsControllerView.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import "EventsView.h"

@implementation EventsView

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
    UIImage *backgroundImage = [self butttonBackgroundImage];
    [self setBackgroundImage:backgroundImage forButton:calendarButton];
    [self setBackgroundImage:backgroundImage forButton:eventsTypeButton];
    [self setBackgroundImage:backgroundImage forButton:addEventButton];
}

- (void) setBackgroundImage:(UIImage *) image forButton:(UIButton *) button
{
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
}

- (UIImage *) butttonBackgroundImage
{
    UIImage *background = [UIImage imageNamed:@"button_background"];
    CGFloat middleX = background.size.width / 2;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, middleX, background.size.height, middleX);
    return [background resizableImageWithCapInsets:edgeInsets];
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
