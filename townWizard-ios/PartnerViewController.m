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
#import "AppDelegate.h"
#import "MenuButtonTutorialViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface PartnerViewController () <PartnerMenuDelegate, MenuButtonTutorialViewControllerDelegate>
{
    UIImageView *splashImage;
}

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) PartnerMenuViewController *menuController;
@property (nonatomic, retain) UINavigationController *detailsController;
@property (nonatomic, retain) SectionControllerFactory *sectionControllerFactory;

@property (nonatomic, retain) UIWindow *tutorialWindow;
@property (nonatomic, retain) UIWindow *mainWindow;
@property (nonatomic, retain) MenuButtonTutorialViewController *menuButtonTutorialViewController;

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
    self.menuButtonTutorialViewController.delegate = nil;

    [splashImage release];
    [_partner release];
    [_progressHUD release];
    [_tutorialWindow release];
    [_mainWindow release];
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

        if ( ! self.tutorialWindow)
        {
            [self showMenuTutorial];
        }

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

- (void)showMenuTutorial
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // reset user default for debug
    //NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    //[userDefaults removePersistentDomainForName:domainName];


    BOOL showTutorial;
    id test = [userDefaults objectForKey:@"showTutorialScreen"];
    if ( ! test)  // first app run
    {
        [userDefaults setBool:YES
                       forKey:@"showTutorialScreen"];
        showTutorial = YES;
        [userDefaults synchronize];
    }
    else
    {
        showTutorial = [(NSNumber *)test boolValue];
    }



    if (showTutorial)
        [self showTutorialWindow];
}

- (void)showTutorialWindow
{
    // get current main app window
    AppDelegate* myDelegate = (((AppDelegate *) [[UIApplication sharedApplication] delegate]));
    self.mainWindow = myDelegate.window;

    // instantiate new tutorial window
    self.tutorialWindow = [[[UIWindow alloc] initWithFrame:self.view.bounds] autorelease];
    self.tutorialWindow.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];

    // instantiate new tutorial VC
    self.menuButtonTutorialViewController = [[[MenuButtonTutorialViewController alloc] initWithNibName:@"MenuButtonTutorialViewController"
                                                                                                bundle:nil] autorelease];
    self.menuButtonTutorialViewController.delegate = self;

    // show tutorial window
    [self.tutorialWindow makeKeyAndVisible];

    // animate
    __block typeof(self) weakSelf = self;
    [UIView transitionWithView:self.mainWindow
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        weakSelf.tutorialWindow.rootViewController = self.menuButtonTutorialViewController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil
    ];
}

- (void)dismissTutorialWithCompletionBlock:(void(^)(void))callback
{
    // animate back to main window
    [UIView transitionWithView:self.mainWindow
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.tutorialWindow.rootViewController = nil;
                        self.tutorialWindow.backgroundColor = [UIColor clearColor];

                    }
                    completion:^(BOOL finished){
                        [self.mainWindow makeKeyAndVisible];
                        if (callback)
                        {
                            callback();
                        }
                    }
    ];
}

- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController
                          dismissPressed:(UIButton *)sender
{
    [self dismissTutorialWithCompletionBlock:nil];
}

- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController
                         dontShowPressed:(UIButton *)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"showTutorialScreen"];
    [userDefaults synchronize];

    [self dismissTutorialWithCompletionBlock:nil];
}

- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController
                           menuButtonHit:(UIButton *)menuButton
{
    __block typeof(self) weakSelf = self;
    [self dismissTutorialWithCompletionBlock:^{
        [weakSelf toggleMasterView];
    }];
}



@end
