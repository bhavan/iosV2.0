//
//  WebImageGridViewCell.m
//  30A
//
//  Created by Vilimets Anton on 9/7/12.
//
//


#import "WebImageGridViewCell.h"

@interface WebImageGridViewCell ()
@property (nonatomic, retain, readwrite) UIImageView *imageView;
@end

@implementation WebImageGridViewCell

@synthesize imageView;

#pragma mark -
#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [[self contentView] addSubview:[self imageView]];
    }
    return self;
}

- (void) dealloc
{
    [self setImageView:nil];
    [super dealloc];
}


#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    [[self imageView] setFrame:[self bounds]];
}

@end
