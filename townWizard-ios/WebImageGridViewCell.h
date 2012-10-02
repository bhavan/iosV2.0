//
//  WebImageGridViewCell.h
//  30A
//
//  Created by Vilimets Anton on 9/7/12.
//
//

#import "AQGridViewCell.h"


@interface WebImageGridViewCell : AQGridViewCell {
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;

- (void)initializeCell;

@end
