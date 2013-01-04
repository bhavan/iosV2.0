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
#import "Event.h"
#import "UIButton+Extensions.h"

@implementation EventDetailTopView


- (void)awakeFromNib
{
    [super awakeFromNib];
    [_callButton setButtonBackgroundImage];
    [_webButton setButtonBackgroundImage];
    [_mapButton setButtonBackgroundImage];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"events_pattern_bg"]];
    [_bgView setBackgroundColor:backgroundColor];
    
}

- (void)updateWithEvent:(Event *)event
{
    NSString *content = [NSString stringWithFormat:@"<html><head>  \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-family: \"helvetica\";}\n"
                         "</style></head>  \n"
                         "<body><h3>%@</h3><b>%@</b><br><b>%@</b><br><br>%@</body></html>",
                         event.title, event.location.name,event.location.address, event.details];
    [_detailWebView loadHTMLString:content baseURL:nil];
    if(event.location.phone.length > 0)
    {
        _callButton.hidden = NO;
        [_callButton setTitle:event.location.phone forState:UIControlStateNormal];
    }
    else
    {
        _callButton.hidden = YES;
    }
}

- (void)dealloc
{    
    [_callButton release];
    [_webButton release];
    [_mapButton release];
    [_bgView release];    
    [_detailWebView release];
    [super dealloc];
}
@end
