//
//  UIButton+Extensions.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/4/13.
//
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)
#define SPINNER_SIZE 25
#pragma mark -
#pragma mark drawing

- (void)setButtonBackgroundImage
{
    [self setBackgroundColor:[UIColor clearColor]];
    UIImage *background = [UIImage imageNamed:@"button_background"];
    CGFloat middleX = background.size.width / 2;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, middleX, background.size.height, middleX);
    UIImage *bg = [background resizableImageWithCapInsets:edgeInsets];
    [self setBackgroundImage:bg forState:UIControlStateNormal];
}


- (void)addSpinner
{
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize buttonSize = self.frame.size;
    spinner.frame = CGRectMake(buttonSize.width/2-SPINNER_SIZE/2, buttonSize.height/2 - SPINNER_SIZE/2,
                               SPINNER_SIZE, SPINNER_SIZE);
    [self addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
}

- (void)removeSpinner
{
    for (UIView * view in self.subviews)
    {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
    }
}

@end
