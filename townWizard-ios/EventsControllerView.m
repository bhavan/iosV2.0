//
//  EventsControllerView.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import "EventsControllerView.h"

@implementation EventsControllerView

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setButtonsBackground];
    [self setBackgroundColorForTableSubviews];
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
    UIImage *background = [UIImage imageNamed:@"button_Background"];
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


#pragma mark -
#pragma mark drawing

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray* colors = @[
        (id)[[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor],
        (id)[[UIColor colorWithRed:1. green:1. blue:1. alpha:1.] CGColor],
    ];
        
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointZero,
                                CGPointMake(0, [self bounds].size.width),
                                0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
