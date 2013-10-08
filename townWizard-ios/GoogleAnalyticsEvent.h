//
//  GoogleAnalyticsEvent.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/8/13.
//
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsEvent : NSObject

- (void)send;

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDescription;

@end
