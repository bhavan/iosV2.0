//
//  DDPageControlCustom.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/26/12.
//
//

#import "DDPageControlCustom.h"

@interface DDPageControlCustom ()
@property (nonatomic, retain) UIImage *activeDotImage;
@property (nonatomic, retain) UIImage *inactiveDotImage;
@end

@implementation DDPageControlCustom

#pragma mark -
#pragma mark life cycle

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.activeDotImage = [UIImage imageNamed:@"page_control_selected"];
        self.inactiveDotImage = [UIImage imageNamed:@"page_control"];
        
        CGFloat currentWidth = [self bounds].size.width;
        CGFloat currentHeight = [self bounds].size.height;
        CGFloat spaceLength = numberOfPages * [self indicatorSpace];
        
        CGFloat dotDiameter = MIN((currentWidth - spaceLength) / numberOfPages, currentHeight);
        dotDiameter = MIN(dotDiameter, [self activeDotImage].size.width);
        [self setIndicatorDiameter:dotDiameter];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) dealloc
{
    [self setActiveDotImage:nil];
    [self setInactiveDotImage:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark drawing

- (void) drawRect:(CGRect)rect
{
    CGFloat currentWidth = [self bounds].size.width;
    CGFloat currentHeight = [self bounds].size.height;
    CGFloat spaceLength = (numberOfPages - 1) * [self indicatorSpace];
    
    CGFloat dotDiameter = MIN((currentWidth - spaceLength) / numberOfPages, currentHeight);
    dotDiameter = MIN(dotDiameter, [self activeDotImage].size.width);

    CGFloat dotsWidth = [self numberOfPages] * dotDiameter + spaceLength;
	CGFloat x = (currentWidth - dotsWidth) / 2 ;
	CGFloat y = (currentHeight - dotDiameter) / 2 ;

    for (int i = 0 ; i < numberOfPages ; i++) {
        UIImage *image = (i == currentPage) ? [self activeDotImage] : [self inactiveDotImage];
        [image drawAtPoint:CGPointMake(x, y)];		
		x += dotDiameter + [self indicatorDiameter];
	}
}

@end
