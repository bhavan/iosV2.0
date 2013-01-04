//
//  UITableViewCell+Spinner.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/4/13.
//
//

#import "UITableViewCell+Spinner.h"

@implementation UITableViewCell (Spinner)

#pragma mark -
#pragma mark Spinner methods

#define SPINNER_SIZE 25

- (void)removeSpinnerFromCell
{
    for (UIView * view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIActivityIndicatorView class]])
            [view removeFromSuperview];
    }
}

- (void)addSpinnerToCell
{
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize cellSize = self.frame.size;
    spinner.frame = CGRectMake(cellSize.width/2-SPINNER_SIZE/2, cellSize.height/2 - SPINNER_SIZE/2,
                               SPINNER_SIZE, SPINNER_SIZE);
    
    self.textLabel.text = nil;
    [self.contentView  addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
}


@end
