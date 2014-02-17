//
//  townWIzardNavigation.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TownWizardNavigationBar.h"

static const CGFloat kTWBarOriginX = 160;
static const CGFloat kTWBarTitleFontSize = 18;

@implementation TownWizardNavigationBar

#pragma mark -
#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor lightGrayColor];
        self.delegate = self;
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kTWBarTitleFontSize];
        background = [UIImage imageNamed:@"navigation_bar_bg"];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc
{
    [self setTitleLabel:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark drawing

- (void) drawRect:(CGRect)rect
{
    [background drawInRect:[self bounds]];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];    
    [[self titleLabel] setFrame:[self calculateTitleFrame]];
    
    UINavigationItem *item = [[self items] lastObject];
    UIView *buttonView = [[item leftBarButtonItem] customView];
    
    CGRect buttonViewFrame = [buttonView frame];
    buttonViewFrame.origin.x = 5;
    
    [buttonView setFrame:buttonViewFrame];
}

- (CGRect)calculateTitleFrame
{
    CGRect titleFrame = [[self titleLabel] frame];
    CGFloat originY = roundf(([self bounds].size.height - [[[self titleLabel] font] pointSize]) / 2);
    
    titleFrame.origin = CGPointMake(40, originY - 2);
    titleFrame.size.width = 240;
    return titleFrame;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    return YES;
}

#pragma mark -
#pragma mark public method

- (void) updateTitleText:(NSString *) titleText
{
    [[self titleLabel] setText:titleText];
    [[self titleLabel] sizeToFit];
}

@end
