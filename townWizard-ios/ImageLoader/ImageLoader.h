//
//  ImageLoader.h
//  ImageLoaderTest
//
//  Created by Evgeniy Kirpichenko on 1/17/12.
//  Copyright (c) 2012 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoadingOperation.h"

@protocol ImageLoaderDelegate
@optional
- (void) imageLoadingCompleted:(UIImage *) image byUrlPath:(NSString *) urlPath;
- (void) imageLoadingFailed:(NSError *) error byUrlPath:(NSString *) urlPath;
@end

@interface ImageLoader : NSObject <ImageLoadingOperationDelegate> {
    NSOperationQueue *loadingOperationsQueue;
    NSMutableDictionary *observers;
    NSMutableDictionary *imagesCache;
}

+ (ImageLoader *) instance;

- (void) loadImageByUrl:(NSURL *) imageUrl;
- (void) loadImageByUrl:(NSURL *) imageUrl observer:(id <ImageLoaderDelegate>) delegate; 
- (void) loadImageByUrlPath:(NSString *) urlPath observer:(id <ImageLoaderDelegate>) observer;

- (void) cleanImagesCache;

- (void) addObserver:(id) observer forLoadingImageByUrlPath:(NSString *) urlPath;
- (void) removeObserver:(id) observer forLoadingImageByUrlPath:(NSString *) urlPath;
- (void) removeObserversForImageByUrlPath:(NSString *) urlPath;

@end
