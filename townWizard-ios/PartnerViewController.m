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

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface PartnerViewController () <PartnerMenuDelegate>
{
    UIImageView *splashImage;
}

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) PartnerMenuViewController *menuController;
@property (nonatomic, retain) UINavigationController *detailsController;
@property (nonatomic, retain) SectionControllerFactory *sectionControllerFactory;

@property (nonatomic, retain) UIWindow *tutorialWindow;
@property (nonatomic, retain) UIWindow *mainWindow;

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


    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];

    [self showMenuTutorial];
}

- (void) dealloc
{
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
         UIViewController *controller = [[self sectionControllerFactory] sectionControllerForSection:section];
        [[self detailsController] setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
        [(TownWizardNavigationBar *)[_detailsController navigationBar]
         updateTitleText:[section displayName]];
        UIBarButtonItem *menuButton = [UIBarButtonItem menuButtonWithTarget:self
                                                                     action:@selector(toggleMasterView)];
        [[(id)controller navigationItem] setLeftBarButtonItem:menuButton];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showMenuTutorial
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

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
    AppDelegate* myDelegate = (((AppDelegate *) [[UIApplication sharedApplication] delegate]));
    self.mainWindow = myDelegate.window;




    self.tutorialWindow = [[[UIWindow alloc] initWithFrame:self.view.bounds] autorelease];

    self.tutorialWindow.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7];


    int menuButtonX = 7;
    int menuButtonY = 7;
    int menuLabelX = 40;
    int menuLabelY = 40;
    if ( ! SYSTEM_VERSION_LESS_THAN(@"7.0")) // ios 7
    {
        menuButtonX = 15;
        menuButtonY = 25;
        menuLabelX = 48;
        menuLabelY = 58;
    }



    UIImage *menuButtonImage = [UIImage imageNamed:@"menu"];
    UIImageView *menuButtonImageView = [[[UIImageView alloc] initWithImage:menuButtonImage] autorelease];
    menuButtonImageView.frame = CGRectMake(menuButtonX, menuButtonY, menuButtonImage.size.width, menuButtonImage.size.height);
    [self.tutorialWindow addSubview:menuButtonImageView];



    UILabel *menuLabel = [[[UILabel alloc] initWithFrame:CGRectMake(menuLabelX, menuLabelY, 200, 20)] autorelease];
    menuLabel.text = @"Menu button";
    menuLabel.textColor = [UIColor whiteColor];
    menuLabel.font = [UIFont boldSystemFontOfSize:18];
    menuLabel.backgroundColor = [UIColor clearColor];
    [self.tutorialWindow addSubview:menuLabel];



    UILabel *descriptionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)] autorelease];
    descriptionLabel.center = CGPointMake(self.tutorialWindow.center.x, self.tutorialWindow.center.y - 60);
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"You can press menu button to access menu items.";
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont boldSystemFontOfSize:18];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.tutorialWindow addSubview:descriptionLabel];



    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dismissButton addTarget:self
                      action:@selector(dismissTutorialButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
    dismissButton.frame = CGRectMake(self.tutorialWindow.center.x - 90, self.tutorialWindow.bounds.size.height - 200, 180, 44);
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    dismissButton.titleLabel.textColor = [UIColor darkGrayColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [dismissButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.tutorialWindow addSubview:dismissButton];



    UIButton *dontShowThisAgain = [UIButton buttonWithType:UIButtonTypeSystem];
    [dontShowThisAgain addTarget:self
                          action:@selector(dontShowThisAgainTutorialButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    dontShowThisAgain.frame = CGRectMake(self.tutorialWindow.center.x - 90, self.tutorialWindow.bounds.size.height - 136, 180, 44);
    [dontShowThisAgain setTitle:@"Don't show anymore" forState:UIControlStateNormal];
    [dontShowThisAgain.titleLabel setFont:[UIFont systemFontOfSize:18]];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [dontShowThisAgain setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [dontShowThisAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.tutorialWindow addSubview:dontShowThisAgain];


    [self.tutorialWindow makeKeyAndVisible];
}

- (void)dismissTutorialButtonPressed
{
    [self.mainWindow makeKeyAndVisible];
    [_mainWindow release];
}

- (void)dontShowThisAgainTutorialButtonPressed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"showTutorialScreen"];
    [userDefaults synchronize];

    [self dismissTutorialButtonPressed];
}

@end
