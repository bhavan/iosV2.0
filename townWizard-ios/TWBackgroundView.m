//
//  TWBackgroundView.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import "TWBackgroundView.h"

@implementation TWBackgroundView

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
                                CGPointMake(0, [self bounds].size.height),
                                0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *logo = [UIImage imageNamed:@"tw_bg_logo"];
    [logo drawAtPoint:CGPointMake(40, 180)];
}


@end
