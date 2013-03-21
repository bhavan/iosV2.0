//
//  PMDimmingView.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/18/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMDimmingView.h"
#import "PMCalendarConstants.h"
#import "PMCalendarController.h"
#import "PMCalendarHelpers.h"

@implementation PMDimmingView

@synthesize controller = _controller;

- (id)initWithFrame:(CGRect)frame controller:(PMCalendarController*)controller
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    
    self.controller = controller;
    self.backgroundColor = UIColorMakeRGBA(0, 0, 0, 0.3);
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:self.frame toView:self];
    
    //self.backgroundColor = UIColorMakeRGBA(0, 0, 0, 1.5);
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    okButton.frame = CGRectMake(50, 325, 100, 40);
    [self addSubview:okButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(180, 325, 100, 40);
    [self addSubview:cancelButton];
    
    return self;
}

- (void)okButtonPressed
{
    self.controller.isCalendarCanceled = NO;
    if (![self.controller.delegate respondsToSelector:@selector(calendarControllerShouldDismissCalendar:)]
        || [self.controller.delegate calendarControllerShouldDismissCalendar:self.controller])
    {
        
        [self.controller dismissCalendarAnimated:YES];
    }
}

- (void)cancelButtonPressed
{
    self.controller.isCalendarCanceled = YES;
    if (![self.controller.delegate respondsToSelector:@selector(calendarControllerShouldDismissCalendar:)]
        || [self.controller.delegate calendarControllerShouldDismissCalendar:self.controller])
    {
        
        [self.controller dismissCalendarAnimated:YES];
    }
}

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.controller.delegate respondsToSelector:@selector(calendarControllerShouldDismissCalendar:)]
        || [self.controller.delegate calendarControllerShouldDismissCalendar:self.controller])
    {
        [self.controller dismissCalendarAnimated:YES];
    }
}*/

@end
