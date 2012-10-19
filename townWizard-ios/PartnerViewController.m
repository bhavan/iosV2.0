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

@interface PartnerViewController () <PartnerMenuDelegate>
@property (nonatomic, retain, readwrite) Partner *partner;
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
    UINavigationController *detailsController = [[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class]
                                                                                              toolbarClass:nil];
    if (self = [super initWithMasterViewController:menuController detailViewController:detailsController]) {
        [self setPartner:partner];
        
        [self setMenuController:menuController];
        [[self menuController] setPartner:partner];
        [[self menuController] setDelegate:self];
        
        [self setDetailsController:detailsController];
        [self setSectionControllerFactory:[[SectionControllerFactory new] autorelease]];
    }
    return self;
}

- (void) dealloc
{
    [self setPartner:nil];
    [self setMenuController:nil];
    [self setDetailsController:nil];
    [self setSectionControllerFactory:nil];

    [super dealloc];
}


- (void) asd {
//    PartnerMenuViewController *subMenu = [[PartnerMenuViewController alloc]
//                                          initWithNibName:@"PartnerMenuViewController"
//                                          bundle:nil];
//    
//    subMenu.partner = aPartner;
//    UINavigationController *newNav = [[UINavigationController alloc] initWithNavigationBarClass:[TownWizardNavigationBar class] toolbarClass:[UIToolbar class]];
//    SubMenuViewController *nMenu = [SubMenuViewController new];
//    nMenu.delegate = self;
//    [newNav pushViewController:nMenu animated:NO];
//    MasterDetailController *master = [[[MasterDetailController alloc] initWithMasterViewController:subMenu detailViewController:newNav] autorelease];
//    TownWizardNavigationBar *navigationBar = (TownWizardNavigationBar *)newNav.navigationBar;
//    navigationBar.masterDetail = master;
//    subMenu.childNavigationController = newNav;
//    [newNav release];
}

#pragma mark -
#pragma mark PartnerMenuDelegate methods

- (void) menuSectionTapped:(Section *) section
{
    UIViewController *controller = [[self sectionControllerFactory] sectionControllerForSection:section];
    NSArray *controllers = [NSArray arrayWithObject:controller];
    [[self detailsController] setViewControllers:controllers animated:YES];
}

- (void) changePartnerButtonTapped
{
    NSLog(@"Change partner");
}

@end
