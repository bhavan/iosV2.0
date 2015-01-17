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
#import "SHKConfiguration.h"
#import "TWShareKitConfigurator.h"
#import "PartnerViewController.h"
#import <RestKit/RestKit.h>
#import <GAI.h>
#import "Appirater.h"
#import "Reachability.h"

#ifdef RUN_KIF_TESTS
#import "EXTestController.h"
#endif

@interface AppDelegate (Private)
- (void)startContainerApp;
- (void)configureNavBar;
- (void)configureLibraries;
@end

@implementation AppDelegate
@dynamic latitude;
@dynamic longitude;

static NSString *partnerId = @"1";
static NSString *twGAcode = @"UA-31932515-2";


@synthesize viewController = _viewController;
@synthesize facebookHelper=_facebookHelper;
@synthesize manager=_manager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [self configureNavBar];
    [self configureLibraries];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    _manager = [[CLLocationManager alloc] init];
    [_manager startUpdatingLocation];
#ifdef CONTAINER_APP
    [self startContainerApp];
#else
    UIViewController *rootController = [[[PartnerViewController alloc] initWithPartner:nil] autorelease];
    self.window.rootViewController = rootController;
#endif
    
    [self.window makeKeyAndVisible];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:4];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)startContainerApp
{
    UIViewController *rootController = [[[SearchViewController alloc] init] autorelease];
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class]
                                                                                          toolbarClass:nil];
    [navController pushViewController:rootController animated:NO];

    PartnerMenuViewController *menuController = [PartnerMenuViewController new];
    menuController.delegate = (SearchViewController *)rootController;
    ((SearchViewController *)rootController).defaultMenu = menuController;
    
    MasterDetailController *masterDetails = [[MasterDetailController alloc] initWithMasterViewController:menuController
                                                                                    detailViewController:navController];
    self.window.rootViewController = [masterDetails autorelease];
    [navController release];
    
    //self.viewController = self.window.rootViewController;
    ((SearchViewController *)rootController).masterDetail = (MasterDetailController *)self.window.rootViewController;
    
    //    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [Appirater setAppId:@"507216232"];
}

- (void)configureNavBar
{
    UIImage *buttonImage = [[UIImage imageNamed:@"backButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 10)];
    [[UIBarButtonItem appearanceWhenContainedIn:[TownWizardNavigationBar class], nil] setBackButtonBackgroundImage:buttonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                    [UIFont boldSystemFontOfSize:13.0f], UITextAttributeFont,
                                    nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[TownWizardNavigationBar class], nil] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}

- (void)configureLibraries
{
    DefaultSHKConfigurator *configurator = [[[TWShareKitConfigurator alloc] init] autorelease];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    [[GAI sharedInstance] trackerWithTrackingId:twGAcode];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

-(NSString*) latitude
{
    CGFloat lat = [self.manager location].coordinate.latitude;
    return [NSString stringWithFormat:@"%f", lat];
}

-(NSString*) longitude
{
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

+ (NSString *) partnerId
{
    return partnerId;
}

- (FacebookHelper*) facebookHelper
{
	if (_facebookHelper == nil)
    {
		_facebookHelper = [[FacebookHelper alloc] init];
	}
	return _facebookHelper;
}


#pragma mark -
#pragma mark shared Application methods

+ (AppDelegate *) sharedDelegate
{
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_facebookHelper release];
    [super dealloc];
}


@end
