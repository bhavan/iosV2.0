//
//  PartnerViewController.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import "PartnerViewController.h"
#import "PartnerMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "SectionControllerFactory.h"
#import "RequestHelper.h"
#import "Section.h"
#import "UIBarButtonItem+TWButtons.h"
#import "MBProgressHUD.h"


@interface PartnerViewController () <PartnerMenuDelegate>
{
    UIImageView *splashImage;
}

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) PartnerMenuViewController *menuController;
@property (nonatomic, retain) UINavigationController *detailsController;
@property (nonatomic, retain) SectionControllerFactory *sectionControllerFactory;
@end

@implementation PartnerViewController

#pragma mark -
#pragma mark life cycle

- (id) initWithPartner:(Partner *)partner
{
    PartnerMenuViewController *menuController = [[PartnerMenuViewController new] autorelease];
    UINavigationController *detailsController = [[[UINavigationController alloc]
                                                  initWithNavigationBarClass:[TownWizardNavigationBar class]
                                                  toolbarClass:nil] autorelease];
    detailsController.navigationBar.translucent = NO;
    
    if (self = [super initWithMasterViewController:menuController detailViewController:detailsController])
    {
        [self setProgressHUD:[[[MBProgressHUD alloc] initWithView:detailsController.view] autorelease]];
        self.partner = partner;
        [self setMenuController:menuController];
        [[self menuController] setPartner:partner];
        [[self menuController] setDelegate:self];
           
        [self setSectionControllerFactory:[[SectionControllerFactory new] autorelease]];        
        [self setDetailsController:detailsController];
        [[detailsController navigationItem] setHidesBackButton:YES];
        
        [[RequestHelper sharedInstance] setCurrentPartner:partner];
        [[RequestHelper sharedInstance] setCurrentSection:nil];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    splashImage = [[UIImageView alloc] initWithFrame:[[self view] frame]];
    [splashImage setImage:[UIImage imageNamed:@"Default"]];
   
    //splashImage.hidden = YES;
    CGRect backgroundViewFrame = [[self view] frame];
    backgroundViewFrame.origin = CGPointZero;   
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:backgroundViewFrame
                                                         toView:self.detailsController.view];
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:backgroundViewFrame
                                                         toView:self.menuController.view];
    [self.detailsController.view addSubview:splashImage];    
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
}

- (void) dealloc
{
    [splashImage release];
    [_partner release];
    [_progressHUD release];
    [self setMenuController:nil];
    [self setDetailsController:nil];
    [self setSectionControllerFactory:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark PartnerMenuDelegate methods

- (void)startUpdating
{
    splashImage.hidden = NO;
    [_progressHUD show:YES];
}

- (void)stopUpdating
{
    splashImage.hidden = YES;
    [_progressHUD hide:YES];
}

- (void) sectionsUpdated:(NSArray *) sections
{   
    
    if ([self.partner.name isEqualToString:DEFAULT_PARTNER_NAME])
    {
         [self toggleMasterView];
    }
    else
    {
        for (Section *section in sections)
        {
            if ([[section name] isEqualToString:@"News"] || [[section name] isEqualToString:@"Home"])
            {
                [self displayControllerForSection:section];
                return;
            }
        }
        if ([sections count])
        {
            [self displayControllerForSection:[sections objectAtIndex:0]];
        }
    }    
}

- (void) menuSectionTapped:(Section *) section
{
    [self displayControllerForSection:section];    
    [self toggleMasterView];
    
    Section *currentSection = [[RequestHelper sharedInstance] currentSection];
    [self trackSectionTap:currentSection];
}

- (void)trackSectionTap:(Section *)section
{
    GoogleAnalyticsEvent *analyticsEvent = [[GoogleAnalyticsEvent new] autorelease];
    [analyticsEvent setEventName:@"menu-item-clicked"];
    [analyticsEvent setEventDescription:[section name]];
    [analyticsEvent send];
}

- (void) changePartnerButtonTapped
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark helpers

- (void) displayControllerForSection:(Section *) section
{
    Section *currentSection = [[RequestHelper sharedInstance] currentSection];
    if (![currentSection isEqual:section])
    {
        [[RequestHelper sharedInstance] setCurrentSection:section];
        
        UIViewController *controller = [self controllerForSection:section];
        UINavigationController *navigationController = [self detailsController];
        [navigationController setViewControllers:@[controller] animated:NO];

        TownWizardNavigationBar *navigationBar = (TownWizardNavigationBar *)[[self detailsController] navigationBar];
        [navigationBar updateTitleText:[section displayName]];
        
        UIBarButtonItem *menuButton = [UIBarButtonItem menuButtonWithTarget:self action:@selector(toggleMasterView)];
        [[controller navigationItem] setLeftBarButtonItem:menuButton];
    }
}

- (UIViewController *)controllerForSection:(Section *)section {
    UIViewController *controller = [[self sectionControllerFactory] sectionControllerForSection:section];

    if ([controller isKindOfClass:[GAITrackedViewController class]]) {
        Partner *partner = [[RequestHelper sharedInstance] currentPartner];
        
        NSString *cityName = [[[partner locations] firstObject] city];
        NSString *sectionName = [section name];
        NSString *trackedViewName = [NSString stringWithFormat:@"%@ : %@", cityName, sectionName];
        
        [(GAITrackedViewController *)controller setTrackedViewName:trackedViewName];
    }
    
    return controller;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
