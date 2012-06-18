//
//  RHRequestDelegate.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 6/14/12.
//  Copyright (c) 2012 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWRequest;

@protocol RWRequestDelegate <NSObject>
@optional
- (void) requestWillStartLoading:(RWRequest *) request;
- (void) requestDidStartLoading:(RWRequest *) request;
- (void) requestDidFinishLoading:(RWRequest *) request;
- (void) requestDidFail:(RWRequest *) request;
- (void) requestDidCancelled:(RWRequest *) request;
@end
