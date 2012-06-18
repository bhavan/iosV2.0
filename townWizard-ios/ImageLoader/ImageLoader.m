//
//  ImageLoader.m
//  ImageLoaderTest
//
//  Created by Evgeniy Kirpichenko on 1/17/12.
//  Copyright (c) 2012 MLS. All rights reserved.
//

#import "ImageLoader.h"

static ImageLoader *imageLoader = nil;

@interface ImageLoader (PrivateMethods)
- (UIImage *) imageFromCacheByUrlPath:(NSString *) urlPath;
- (void) addImage:(UIImage *) image loadedByUrlPath:(NSString *) urlPath;

- (BOOL) imageLoadingInProgressByUrlPath:(NSString *) urlPath;
- (void) addObserver:(id) observer forLoadingImageByUrlPath:(NSString *) urlPath;
@end

@implementation ImageLoader

#pragma mark -
#pragma mark life cycle

+ (ImageLoader *) instance {
    @synchronized(self) {
        if (imageLoader == nil)
            imageLoader = [[self alloc] init];
    }    
    return(imageLoader);
}

- (id) init {
    if ((self = [super init])) {
        loadingOperationsQueue = [[NSOperationQueue alloc] init];
        observers = [[NSMutableDictionary alloc] init];
        imagesCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [loadingOperationsQueue release];
    [observers release];
    [imagesCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark image loading methods

- (void) loadImageByUrl:(NSURL *) imageUrl observer:(id <ImageLoaderDelegate>) observer {
    NSString *imageUrlPath = [imageUrl absoluteString];
    UIImage *cacheImage = [self imageFromCacheByUrlPath:imageUrlPath];
    if (!cacheImage) {
        if (![self imageLoadingInProgressByUrlPath:imageUrlPath]) {
            [self loadImageByUrl:imageUrl];
        }
        [self addObserver:observer forLoadingImageByUrlPath:imageUrlPath];
    }
    else {
        [observer imageLoadingCompleted:cacheImage byUrlPath:imageUrlPath];
    }
}

- (void) loadImageByUrlPath:(NSString *) urlPath observer:(id <ImageLoaderDelegate>) observer {
    if (urlPath) {
        NSURL *url = [[NSURL alloc] initWithString:urlPath];
        [self loadImageByUrl:url observer:observer];
        [url release];
    }    
}

- (void) loadImageByUrl:(NSURL *) imageUrl {
    if (imageUrl) {
        ImageLoadingOperation *operation = [[ImageLoadingOperation alloc] initWithImageUrl:imageUrl
                                                                                  delegate:self];
        [operation setQueuePriority:NSOperationQueuePriorityVeryLow];
        [loadingOperationsQueue addOperation:operation];
        [operation release];
    }    
}

#pragma mark -
#pragma mark cache helpers

- (UIImage *) imageFromCacheByUrlPath:(NSString *) urlPath {
    if (urlPath) {
        return [imagesCache objectForKey:urlPath];
    }
    return nil;
}

- (void) addImage:(UIImage *) image loadedByUrlPath:(NSString *) urlPath {
    if (image && urlPath) {
        [imagesCache setObject:image forKey:urlPath];
    }    
}

- (void) cleanImagesCache {
    [imagesCache removeAllObjects];
}

#pragma mark -
#pragma mark observers helpers

- (BOOL) imageLoadingInProgressByUrlPath:(NSString *) urlPath {
    return [[imagesCache allKeys] containsObject:urlPath];
}

- (void) addObserver:(id) observer forLoadingImageByUrlPath:(NSString *) urlPath {
    if (!urlPath || !observer) {
        return;
    }
    
    NSMutableArray *observersForImage = [observers objectForKey:urlPath];
    if (observersForImage == nil) {
        observersForImage = [[NSMutableArray alloc] init];
        [observers setObject:observersForImage forKey:urlPath];
        [observersForImage release];
    }
    
    [observersForImage addObject:observer];
}

- (void) removeObserver:(id) observer forLoadingImageByUrlPath:(NSString *) urlPath {
    if (!observer || !urlPath) {
        return;
    }
    
    NSMutableArray *observersForImage = [observers objectForKey:urlPath];
    [observersForImage removeObject:observer];
    if ([observersForImage count] == 0) {
        [observers removeObjectForKey:urlPath];
    }
}

- (void) removeObserversForImageByUrlPath:(NSString *) urlPath {
    if (urlPath) {
        [observers removeObjectForKey:urlPath];
    }
}

#pragma mark -
#pragma mark ImageLoadingOperationDelegate methods

- (void) imageLoadingOperationCompleted:(ImageLoadingOperation *) loadingOperation {
    NSString *imageUrlPath = [[loadingOperation imageUrl] absoluteString];
    UIImage *loadedImage = [loadingOperation image];
    
    [imagesCache setObject:[loadingOperation image] forKey:imageUrlPath];
    
    NSMutableArray *imageObservers = [observers objectForKey:imageUrlPath];
    for (id<ImageLoaderDelegate> observer in imageObservers) {
        if ([(id)observer respondsToSelector:@selector(imageLoadingCompleted:byUrlPath:)]) {
            [observer imageLoadingCompleted:loadedImage byUrlPath:imageUrlPath];
        }
    }
    [self removeObserversForImageByUrlPath:imageUrlPath];
}

- (void) imageLoadingOperationFailed:(ImageLoadingOperation *) loadingOperation {
    NSString *imageUrlPath = [[loadingOperation imageUrl] absoluteString];
    
    NSMutableArray *imageObservers = [observers objectForKey:imageUrlPath];
    for (id<ImageLoaderDelegate> observer in imageObservers) {
        if ([(id)observer respondsToSelector:@selector(imageLoadingFailed:byUrlPath:)]) {
            [observer imageLoadingFailed:[loadingOperation error] byUrlPath:imageUrlPath];
        }
    }
    [self removeObserversForImageByUrlPath:imageUrlPath];
}

@end
