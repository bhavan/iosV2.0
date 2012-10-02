//
//  WebImageGridViewCell.m
//  30A
//
//  Created by Vilimets Anton on 9/7/12.
//
//


#import "WebImageGridViewCell.h"

@implementation WebImageGridViewCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
    }
    return self;
}

- (void)initializeCell
{
    imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:imageView];
    self.backgroundColor = [UIColor redColor];
}


@end
