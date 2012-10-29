//
//  ActivityImageView.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import "ActivityImageView.h"

@implementation ActivityImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addActivityIndicator];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addActivityIndicator];
    }
    return self;
}

- (void) dealloc
{
    [_activityIndicator release];
    [super dealloc];
}


#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect indicatorFrame = [_activityIndicator frame];
    indicatorFrame.origin.x = roundf(([self bounds].size.width - indicatorFrame.size.width) / 2);
    indicatorFrame.origin.y = roundf(([self bounds].size.height - indicatorFrame.size.height) / 2);
    [_activityIndicator setFrame:indicatorFrame];
}

#pragma mark -
#pragma mark private methods

- (void) addActivityIndicator
{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    [self addSubview:_activityIndicator];
}

#pragma mark -
#pragma mark image loading

- (void) setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url
         placeholderImage:nil
                  options:SDWebImageCacheMemoryOnly
                  success:nil
                  failure:nil];
}

- (void) setImageWithURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:SDWebImageCacheMemoryOnly
                  success:nil
                  failure:nil];
}

- (void) setImageWithURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholder
                 options:(SDWebImageOptions)options
{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:options
                  success:nil
                  failure:nil];
}

- (void) setImageWithURL:(NSURL *)url
                 success:(SDWebImageSuccessBlock)success
                 failure:(SDWebImageFailureBlock)failure
{
    [self setImageWithURL:url
         placeholderImage:nil
                  options:SDWebImageCacheMemoryOnly
                  success:success
                  failure:failure];
}

- (void) setImageWithURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholder
                 success:(SDWebImageSuccessBlock)success
                 failure:(SDWebImageFailureBlock)failure
{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:SDWebImageCacheMemoryOnly
                  success:success
                  failure:failure];
}

- (void) setImageWithURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholder
                 options:(SDWebImageOptions)options
                 success:(SDWebImageSuccessBlock)success
                 failure:(SDWebImageFailureBlock)failure
{
    [_activityIndicator startAnimating];
    [super setImageWithURL:url
          placeholderImage:placeholder
                   options:options
                   success:^(UIImage *image, BOOL cached){
                       [_activityIndicator stopAnimating];
                       if (success != nil) {
                           success(image,cached);
                       }     
                   }
                   failure:failure];
}



@end
