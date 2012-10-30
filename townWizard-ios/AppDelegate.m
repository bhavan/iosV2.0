//
//  AppDelegate.m
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


#import <RestKit/RestKit.h>

#ifdef RUN_KIF_TESTS
#import "EXTestController.h"
#endif

@implementation AppDelegate
@dynamic latitude;
@dynamic longitude;

static NSString *partnerId = @"1";
static NSString* teamToken = @"5c115b5c0ce101b8b0367b329e68db27_MzE2NjMyMDExLTExLTA3IDAzOjQ5OjEyLjkyNjU4Ng";

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebookHelper=_facebookHelper;
@synthesize manager=_manager;

+ (NSString *) partnerId {
    return partnerId;
}

- (FacebookHelper*) facebookHelper {
	if (_facebookHelper == nil) {
		_facebookHelper = [[FacebookHelper alloc] init];
	}
	return _facebookHelper;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_facebookHelper release];
    [super dealloc];
}

-(NSString*) latitude {
    CGFloat lat = [self.manager location].coordinate.latitude;
    return [NSString stringWithFormat:@"%f", lat];
}

-(NSString*) longitude {
    CGFloat lon = [self.manager location].coordinate.longitude;
    return [NSString stringWithFormat:@"%f", lon];
}

-(double)doubleLatitude
{
    return [self.manager location].coordinate.latitude;
}

-(double)doubleLongitude
{
    return [self.manager location].coordinate.longitude;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    [TestFlight takeOff:teamToken];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIViewController *rootController;
    _manager = [[CLLocationManager alloc] init];
#ifdef CONTAINER_APP
    
    
    rootController = [[[ViewController alloc] init] autorelease];
    [[self manager] setDelegate:(ViewController *)rootController];
#else
    rootController = [[[PartnerMenuViewController alloc] init] autorelease];
#endif
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    self.viewController = navController;
    [navController release];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
#if !RUN_KIF_TESTS
    
    [self.manager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers]; //should be enough
    [self.manager startUpdatingLocation];
#else
    [[EXTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        exit([[EXTestController sharedInstance] failureCount]);
    }];
#endif
    
    return YES;
}

#pragma mark -
#pragma mark shared Application methods

+ (AppDelegate *) sharedDelegate {
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)makeCall:(NSString *)phoneNumber
{
	phoneNumberToCall = [phoneNumber copy];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:phoneNumber
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Call", nil];
	[alert setTag:1];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1)
	{
		if((buttonIndex == 1) && (phoneNumberToCall.length > 0))
		{
            [phoneNumberToCall autorelease];
            phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@"-" withString:@""];
			phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@"(" withString:@""];
			phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@")" withString:@""];
			phoneNumberToCall = [NSString stringWithFormat:@"tel://%@",phoneNumberToCall];
            
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberToCall]];
		}
	}
    else
        [phoneNumberToCall release];
}

@end
