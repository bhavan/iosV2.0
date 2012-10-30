//
//  ResizableButton.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import "ResizableButton.h"

@implementation ResizableButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundImage:[self butttonBackgroundImage] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark -
#pragma mark drawing

- (UIImage *) butttonBackgroundImage
{
    UIImage *background = [UIImage imageNamed:@"button_background"];
    CGFloat middleX = background.size.width / 2;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, middleX, background.size.height, middleX);
    return [background resizableImageWithCapInsets:edgeInsets];
}

@end
