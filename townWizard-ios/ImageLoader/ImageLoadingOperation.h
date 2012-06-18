//
//  ImageLoaderOperation.h
//  ImageLoaderTest
//
//  Created by Evgeniy Kirpichenko on 1/17/12.
//  Copyright (c) 2012 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageLoadingOperationDelegate;

@interface ImageLoadingOperation : NSOperation {
    NSURL *imageUrl;
    UIImage *image;
    NSError *error;
}

- (id) initWithImageUrl:(NSURL *) imageUrl;
- (id) initWithImageUrl:(NSURL *) anImageUrl delegate:(id<ImageLoadingOperationDelegate>) aDelegate;

@property (nonatomic, readonly) NSURL *imageUrl;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, assign) id<ImageLoadingOperationDelegate> delegate;

@end

@protocol ImageLoadingOperationDelegate 
- (void) imageLoadingOperationCompleted:(ImageLoadingOperation *) loadingOperation;
@optional
- (void) imageLoadingOperationFailed:(ImageLoadingOperation *) loadingOperation;
@end
