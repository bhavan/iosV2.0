//
//  ViewController.m
//  MasterDetailview
//
//  Created by Rasmus Styrk on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MASTER_WIDTH 280

const NSTimeInterval kGHRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kGHRevealSidebarFlickVelocity = 1000.0f;

#import "MasterDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterDetailController ()
@property BOOL masterVisible;
@property (nonatomic, retain) UIView *masterView;
@property (nonatomic, retain) UIView *detailView;
@property (nonatomic, retain) UIViewController *masterController;
@property (nonatomic, retain) UIViewController *detailController;
- (void) showMaster: (BOOL) shouldShow;
@end

@implementation MasterDetailController
#pragma mark - Properties -
@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize masterController = _masterController;
@synthesize detailController = _detailController;
@synthesize masterVisible = _masterVisible;

#pragma mark -

- (id) initWithMasterViewController:(UIViewController*)masterController detailViewController:(UIViewController*)detailController
{
    self = [super init];
    
    if(self)
    {
        self.masterController = masterController;
        self.detailController = detailController;
        
        [self.masterController setValue:self forKey:@"parentViewController"];
        [self.detailController setValue:self forKey:@"parentViewController"];
    }
    
    return self;
}

- (void) dealloc
{
    [_masterView release];          
    [_detailView release];    
    [super dealloc];
}

#pragma mark - helpers

- (void) toggleMasterView
{
    [self showMaster:!self.masterVisible];
    [self trackMenuButtonTappingGoogleAnalyticsEvent];
}

// track menu button tap as google analytics event
- (void)trackMenuButtonTappingGoogleAnalyticsEvent {
    GoogleAnalyticsEvent *analyticsEvent = [[GoogleAnalyticsEvent new] autorelease];
    [analyticsEvent setEventName:@"menu-button-clicked"];
    [analyticsEvent setEventDescription:@"Menu button clicked"];
    [analyticsEvent send];
}


- (void) changeDetailView:(UIViewController *)detailController
{
    [self.detailController viewWillDisappear:NO];
    [self.detailController.view removeFromSuperview];
    [self.detailController viewDidDisappear:NO];
    
    self.detailController = detailController;
    
    [self.detailController viewWillAppear:NO];
    [self.detailView addSubview:self.detailController.view];
    [self.detailController viewDidAppear:NO];

}

#pragma mark - View lifecycle

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.masterController = nil;
    self.detailController = nil;
    
    _detailView = nil;
    _masterView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void) loadView
{
    [super loadView];

    self.masterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, MASTER_WIDTH, self.view.frame.size.height)] autorelease];
    
    [self.masterController viewWillAppear:NO];
    [self.masterView addSubview: self.masterController.view];
    [[[self masterController] view] setFrame:[[self masterView] frame]];
    [self.masterController viewDidAppear:NO];

    self.detailView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    
    [self.detailController viewWillAppear:NO];
    [self.detailView addSubview: self.detailController.view];
    [self.detailController viewDidAppear:NO];
    
    self.detailView.layer.shadowOffset = CGSizeMake(-1, -1);
    self.detailView.layer.shadowRadius = 5;
    self.detailView.layer.shadowOpacity = 0.5;
    self.detailView.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    self.detailView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.detailView.bounds].CGPath;

    CGRect masterFrame = self.masterController.view.frame;
    masterFrame.size.width = MASTER_WIDTH;
    
    self.masterController.view.frame = masterFrame;

    [self addChildViewController:self.masterController];
    [self.masterController didMoveToParentViewController:self];
    
    [self addChildViewController:self.detailController];
    [self.detailController didMoveToParentViewController:self];
    
    [self.view addSubview:self.masterView];
    [self.view addSubview:self.detailView];
    
    self.masterView = nil;
}

- (void) showMaster:(BOOL) shouldShow
{
    if(self.masterVisible)
        [self.masterController viewWillDisappear:YES];
    else 
        [self.masterController viewWillAppear:YES];
    
    CGRect frame = self.detailView.frame;
    
    if(shouldShow)
        frame.origin.x = self.view.frame.size.width - (self.view.frame.size.width - MASTER_WIDTH);
    else 
        frame.origin.x = 0;
    
    [UIView beginAnimations:@"master" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(masterDidAnimate:)];
    
    self.detailView.frame = frame;
    
    [UIView commitAnimations];
    
    self.masterVisible = shouldShow;
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void) masterDidAnimate:(id)sender
{
    if(self.masterVisible)
        [self.masterController viewDidAppear:YES];
    else 
        [self.masterController viewDidDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
