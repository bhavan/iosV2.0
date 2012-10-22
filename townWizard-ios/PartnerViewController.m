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
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    PartnerMenuViewController *menuController = [[PartnerMenuViewController new] autorelease];
    UINavigationController *detailsController = [[[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class]
                                                                                              toolbarClass:nil] autorelease];
    
    if (self = [super initWithMasterViewController:menuController detailViewController:detailsController]) {
        [self setMenuController:menuController];
        [[self menuController] setPartner:partner];
        [[self menuController] setDelegate:self];
        
        [self setDetailsController:detailsController];
        [[self.detailsController navigationItem] setHidesBackButton:YES];
        [self setSectionControllerFactory:[[SectionControllerFactory new] autorelease]];
        
        [[RequestHelper sharedInstance] setCurrentPartner:partner];
        [[RequestHelper sharedInstance] setCurrentSection:nil];
    }
    return self;
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

- (void) menuSectionTapped:(Section *) section
{
    Section *currentSection = [[RequestHelper sharedInstance] currentSection];
    if (![currentSection isEqual:section]) {
        [[RequestHelper sharedInstance] setCurrentSection:section];
        
        id<SectionController> controller = [[self sectionControllerFactory] sectionControllerForSection:section];
        if (controller) {
            NSArray *controllers = [NSArray arrayWithObject:controller];
            [[self detailsController] setViewControllers:controllers animated:NO];
            [[(id)controller navigationItem] setLeftBarButtonItem:[self menuButton]];
        }
    }
    
    [self toggleMasterView];
}

- (void) changePartnerButtonTapped
{

}


#pragma mark -
#pragma mark bar buttons

- (void) updateLeftBarButtonForController:(UIViewController *) controller
{
    if ([[[self detailsController] viewControllers] objectAtIndex:0] == controller) {
        [[controller navigationItem] setLeftBarButtonItem:[self menuButton]];
    }
}

- (UIBarButtonItem *) menuButton
{
    UIImage *menuButtonImage = [UIImage imageNamed:@"menuStarButton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:menuButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleMasterView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

@end
