//
//  AppDelegate.m
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "MasterDetailController.h"
#import "TownWIzardNavigationBar.h"
#import "MapViewController.h"
#import "SHKConfiguration.h"
#import "TWShareKitConfigurator.h"

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
    UIImage *buttonImage = [[UIImage imageNamed:@"backButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 10)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonImage
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                    [UIFont boldSystemFontOfSize:13.0f], UITextAttributeFont,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
   
    
    
    DefaultSHKConfigurator *configurator = [[[TWShareKitConfigurator alloc] init] autorelease];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    [TestFlight takeOff:teamToken];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIViewController *rootController;
    _manager = [[CLLocationManager alloc] init];
#ifdef CONTAINER_APP
    rootController = [[[SearchViewController alloc] init] autorelease];
    [[self manager] setDelegate:(SearchViewController *)rootController];
#else
    rootController = [[[PartnerMenuViewController alloc] init] autorelease];
#endif
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class] toolbarClass:nil];
    [navController pushViewController:rootController animated:NO];
    
    // [navController release];
    PartnerMenuViewController *menuController = [PartnerMenuViewController new];
    menuController.delegate = (SearchViewController *)rootController;
    ((SearchViewController *)rootController).defaultMenu = menuController;
    self.window.rootViewController = [[[MasterDetailController alloc] initWithMasterViewController:menuController detailViewController:navController] autorelease];
    //self.viewController = self.window.rootViewController;
    ((SearchViewController *)rootController).masterDetail = (MasterDetailController *)self.window.rootViewController;
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

+ (AppDelegate *) sharedDelegate
{
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
