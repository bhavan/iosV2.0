//
//  AppDelegate.h
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FacebookHelper.h"
#import "UIApplication+NetworkActivity.h"

@class SearchViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate> {

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *viewController;

@property (nonatomic,readonly) NSString* latitude;
@property (nonatomic,readonly) NSString* longitude;

@property (nonatomic,readonly) double doubleLatitude;
@property (nonatomic,readonly) double doubleLongitude;

@property (nonatomic,readonly) FacebookHelper * facebookHelper;

@property (nonatomic,readonly) CLLocationManager * manager;

+ (AppDelegate *) sharedDelegate;
+ (NSString *) partnerId;


@end
