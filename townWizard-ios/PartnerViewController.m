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
#import "TWBackgroundView.h"

@interface PartnerViewController () <PartnerMenuDelegate>
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
    UINavigationController *detailsController = [[[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class]
                                                                                              toolbarClass:nil] autorelease];
    
    if (self = [super initWithMasterViewController:menuController detailViewController:detailsController]) {
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
    
    CGRect backgroundViewFrame = [[self view] frame];
    backgroundViewFrame.origin = CGPointZero;
   
    [[[self detailsController] view] insertSubview:[self twBackgroundWithFrame:backgroundViewFrame] atIndex:0];
    [[[self menuController] view] insertSubview:[self twBackgroundWithFrame:backgroundViewFrame] atIndex:0];
}

- (void) dealloc
{
    [self setMenuController:nil];
    [self setDetailsController:nil];
    [self setSectionControllerFactory:nil];

    [super dealloc];
}

#pragma mark -
#pragma mark PartnerMenuDelegate methods

- (void) sectionsUpdated:(NSArray *) sections
{
    for (Section *section in sections) {
        if ([[section name] isEqualToString:@"News"]) {
            [self displayControllerForSection:section];
            return;
        }
    }

    if ([sections count]) {
        [self displayControllerForSection:[sections objectAtIndex:0]];
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
#pragma mark bar buttons

- (UIBarButtonItem *) menuButton
{
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu_button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:menuButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleMasterView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


#pragma mark -
#pragma mark helpers

- (void) displayControllerForSection:(Section *) section
{
    Section *currentSection = [[RequestHelper sharedInstance] currentSection];
    if (![currentSection isEqual:section]) {
        [[RequestHelper sharedInstance] setCurrentSection:section];
        [section setName:[[section name] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]];
        [section setDisplayName:[[section displayName] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]];
        UIViewController *controller = [[self sectionControllerFactory] sectionControllerForSection:section];
        [[self detailsController] setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
        [(TownWizardNavigationBar *)[_detailsController navigationBar] updateTitleText:[section name]];        
        [[(id)controller navigationItem] setLeftBarButtonItem:[self menuButton]];
    }
}

- (UIView *) twBackgroundWithFrame:(CGRect) frame
{
    TWBackgroundView *backgroundView = [[TWBackgroundView alloc] initWithFrame:frame];
    [[self view] insertSubview:backgroundView atIndex:0];
    return [backgroundView autorelease];
}

@end
