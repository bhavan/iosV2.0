//
//  townWIzardNavigation.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TownWizardNavigationBar.h"
#import <QuartzCore/QuartzCore.h>




static const CGFloat kTWBarOriginX = 55;
static const CGFloat kTWBarTitleFontSize = 18;

@implementation TownWizardNavigationBar

#pragma mark -
#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor lightGrayColor];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kTWBarTitleFontSize];

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
    UIImage *background = [UIImage imageNamed:@"navigation_bar_bg"];
    [background drawInRect:[self bounds]];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = [[self titleLabel] frame];
    CGFloat originY = roundf(([self bounds].size.height - [[[self titleLabel] font] pointSize]) / 2);
    titleFrame.origin = CGPointMake(kTWBarOriginX, originY - 2);
    [[self titleLabel] setFrame:titleFrame];
}

#pragma mark -
#pragma mark public method

- (void) updateTitleText:(NSString *) titleText
{
    [[self titleLabel] setText:titleText];
    [[self titleLabel] sizeToFit];
}

@end
