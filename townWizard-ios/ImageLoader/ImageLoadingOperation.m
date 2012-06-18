//
//  ImageLoaderOperation.m
//  ImageLoaderTest
//
//  Created by Evgeniy Kirpichenko on 1/17/12.
//  Copyright (c) 2012 MLS. All rights reserved.
//

#import "ImageLoadingOperation.h"

@interface ImageLoadingOperation (Private)
- (void) setImageUrl:(NSURL *) imageUrl; 
- (void) setImage:(UIImage *) image;
- (void) notifyThatImageLoadingFailed;
@end

@implementation ImageLoadingOperation

@synthesize imageUrl;
@synthesize image;
@synthesize delegate;
@synthesize error;

#pragma mark -
#pragma mark life cycle

- (id) initWithImageUrl:(NSURL *) anImageUrl {
    if ((self = [super init])) {
        [self setImageUrl:anImageUrl];
    }
    return self;
}

- (id) initWithImageUrl:(NSURL *) anImageUrl delegate:(id<ImageLoadingOperationDelegate>) aDelegate {
    if ((self = [self initWithImageUrl:anImageUrl])) {
        [self setDelegate:aDelegate];
    }
    return self;
}

- (void) dealloc {
    [self setImageUrl:nil];
    [self setImage:nil];
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

- (void) setImageUrl:(NSURL *) anImageUrl {
    if (imageUrl != anImageUrl) {
        [anImageUrl retain];
        [imageUrl release];
        imageUrl = anImageUrl;
    }
}

- (void) setImage:(UIImage *) anImage {
    if (image != anImage) {
        [anImage retain];
        [image release];
        image = anImage;
    }
}

#pragma mark -
#pragma mark loading

- (void) main {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
    NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:nil
                                                          error:&error];
    if (imageData && !error) {
        image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            [(id)delegate performSelectorOnMainThread:@selector(imageLoadingOperationCompleted:) 
                                           withObject:self 
                                        waitUntilDone:YES];
        }
        else {
            error = [NSError errorWithDomain:@"No image by url" 
                                        code:NSFileNoSuchFileError 
                                    userInfo:nil];
            [self notifyThatImageLoadingFailed];
        }
    }
    else {   
        [self notifyThatImageLoadingFailed];
    }
}

- (void) notifyThatImageLoadingFailed {
    SEL selectorForFail = @selector(imageLoadingOperationFailed:);
    if ([(id)delegate respondsToSelector:selectorForFail] ) {
        [(id) delegate performSelectorOnMainThread:selectorForFail
                                        withObject:self
                                     waitUntilDone:YES];
    }
}

@end
