//
//  EventDetailTopView.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import "EventDetailTopView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_callButton setBackgroundImage:[self buttonBackgroundImage] forState:UIControlStateNormal];
    [_webButton setBackgroundImage:[self buttonBackgroundImage] forState:UIControlStateNormal];
    [_mapButton setBackgroundImage:[self buttonBackgroundImage] forState:UIControlStateNormal];
      UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"events_pattern_bg"]];
    [_bgView setBackgroundColor:backgroundColor];
    
}

- (UIImage *)buttonBackgroundImage
{
    UIImage *background = [UIImage imageNamed:@"button_background"];
    CGFloat middleX = background.size.width / 2;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, middleX, background.size.height, middleX);
    return [background resizableImageWithCapInsets:edgeInsets];
}



- (void)dealloc {
    [_eventTitleLabel release];
    [_eventAdress release];
    [_callButton release];
    [_webButton release];
    [_mapButton release];
    [_bgView release];


    [super dealloc];
}
@end
