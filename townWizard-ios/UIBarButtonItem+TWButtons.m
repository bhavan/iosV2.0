//
//  UIBarButtonItem+TWButtons.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/11/13.
//
//

#import "UIBarButtonItem+TWButtons.h"

@implementation UIBarButtonItem (TWButtons)

+ (UIBarButtonItem *) menuButtonWithTarget:(id)target action:(SEL)action
{
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu_button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:menuButtonImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem *) backButtonWithTarget:(id)target action:(SEL)action
{
    UIImage *buttonImage = [[UIImage imageNamed:@"backButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 15)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"  Back" forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem *resultItem = [[[UIBarButtonItem alloc]initWithCustomView:btn] autorelease];
    [btn release];
    return resultItem;
}

@end
