//
//  PartnerMenuViewController.m
//  TownWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PartnerMenuViewController.h"
#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "Section.h"
#import "UIImageView+WebCache.h"
#import "PhotoCategoriesViewController.h"
#import "RequestHelper.h"
#import "VideosViewController.h"
#import "MasterDetailController.h"

#define URL_HEADER @"http://"

@implementation PartnerMenuViewController

@synthesize partnerSections;
@synthesize partner;
@synthesize customNavigationBar;
@synthesize childNavigationController;

@synthesize currentSectionName = _currentSectionName;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        sectionImagesDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavigationBar = (TownWizardNavigationBar *) self.childNavigationController.navigationBar;
    [[self navigationItem] setHidesBackButton:YES];
    
}


-(void)setNameForNavigationBar
{
    self.customNavigationBar.titleLabel.text = self.partner.name;
    if (self.currentSectionName == nil) {
        self.customNavigationBar.subMenuLabel.text = @"";
    }
    else {
        self.customNavigationBar.subMenuLabel.text = self.currentSectionName;
        // self.partner.name,self.currentSectionName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customNavigationBar = (TownWizardNavigationBar *) self.childNavigationController.navigationBar;

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
#ifdef CONTAINER_APP
    
    
    [self setNameForNavigationBar];
#endif
    
    if (self.partner == nil) {
        [self loadPartnerDetails];
    }
    else {
        if (self.partnerSections == nil) {
            [RequestHelper sectionsWithPartner:self.partner andDelegate:self];
        }       
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.customNavigationBar.menuButton removeTarget:self
                                               action:@selector(menuButtonPressed)
                                     forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    
#ifdef PARTNER_ID
    [[[self customNavigationBar] menuButton] setHidden:NO];
#endif
    
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Navigation

- (void)menuButtonPressed
{
}

#define BUTTON_SIZE 100
#define HORIZONTAL_SPACING 140
#define VERTICAL_SPACING 50
#define MINIMUM_SCROLL_VIEW_HEIGHT 400

- (IBAction)changePartnerButtonPressed:(id)sender
{
    MasterDetailController *masterDetail = (MasterDetailController *)self.parentViewController;
    [masterDetail.navigationController popViewControllerAnimated:YES];
}

static NSString * const uploadScriptURL = @"/components/com_shines/iuploadphoto.php";


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.partnerSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Section *section = [self.partnerSections objectAtIndex:indexPath.row];
    cell.textLabel.text = section.displayName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section *section = [partnerSections objectAtIndex:indexPath.row];
    MasterDetailController *masterDetail = (MasterDetailController *)self.parentViewController;
    if ([section.uiType isEqualToString:@"webview"]) {
        
        SubMenuViewController *subMenu = [[SubMenuViewController alloc]
                                          initWithNibName:@"SubMenuViewController" bundle:nil];
        
        subMenu.customNavigationBar = (TownWizardNavigationBar *)self.childNavigationController.navigationBar;
        if(section != nil) {
            subMenu.partner = self.partner;
            subMenu.section = section;
            NSString *urlString =  section.url;
            NSString *urlHeader = [urlString substringToIndex:7];
            NSString *sectionUrl = nil;
            if([urlHeader isEqualToString:URL_HEADER]) {
                sectionUrl = urlString;
            }
            else {
                sectionUrl = [NSString stringWithFormat:@"%@/%@",
                              self.partner.webSiteUrl,
                              section.url];
            }
            subMenu.url = [sectionUrl stringByAppendingFormat:@"?&lat=%f&lon=%f",
                           [AppDelegate sharedDelegate].doubleLatitude,
                           [AppDelegate sharedDelegate].doubleLongitude];
            
        }
        
        [self.childNavigationController pushViewController:subMenu animated:YES];
        [masterDetail toggleMasterView];
        [subMenu release];
        if ([section.name isEqual:@"Photos"])
        {
            dispatch_queue_t checkQueue =  dispatch_queue_create("check reachability", NULL);
            dispatch_async(checkQueue, ^{
                NSString * uploadUrl = [NSString stringWithFormat:@"%@%@",
                                        self.partner.webSiteUrl,
                                        uploadScriptURL];
                if ([Reachability reachabilityWithURL:[NSURL URLWithString:uploadUrl]])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [subMenu showUploadTitle];
                    });
                }
            });
            dispatch_release(checkQueue);
        }
        
    }
    else if ([section.name isEqual:@"Photos"])
    {
        PhotoCategoriesViewController *controller = [PhotoCategoriesViewController new];
        controller.partner = self.partner;
        controller.section = section;
        controller.customNavigationBar = self.customNavigationBar;
        [RequestHelper categoriesWithPartner:self.partner andSection:section andDelegate:controller];
        [self.childNavigationController pushViewController:controller animated:YES];
        [masterDetail toggleMasterView];
        [controller release];
    }
    else if ([section.name isEqual:@"Videos"])
    {
        VideosViewController *controller = [VideosViewController new];
        controller.partner = self.partner;
        controller.section = section;
        controller.customNavigationBar = self.customNavigationBar;
        [RequestHelper videosWithPartner:self.partner andSection:section andDelegate:controller];
        [self.childNavigationController pushViewController:controller animated:YES];
        [masterDetail toggleMasterView];
        [controller release];
    }
    
    if ([[self delegate] respondsToSelector:@selector(menuSectionTapped:)]) {
        [[self delegate] menuSectionTapped:section];
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    if([[objects lastObject] isKindOfClass:[Partner class]]) {
        self.partner = [objects lastObject];
        if (partner.facebookAppId)
        {
            [AppDelegate sharedDelegate].facebookHelper.appId = partner.facebookAppId;
            [TestFlight passCheckpoint:@"facebook app id is set"];
        }
        else {
            [AppDelegate sharedDelegate].facebookHelper.appId = @"";
            [TestFlight passCheckpoint:@"Facebook app id is empty"];
        }
        
        [RequestHelper sectionsWithPartner:self.partner andDelegate:self];
        
    }
    else if([[objects lastObject] isKindOfClass:[Section class]]) {
        self.partnerSections = [[[NSMutableArray alloc]initWithArray:objects] autorelease];
        //[self reloadMenu];
        [self.partnersTableView reloadData];
        
    }
}

- (void) loadPartnerDetails {
#ifdef PARTNER_ID
    [RequestHelper partnerWithId:[NSString stringWithFormat:@"%d",PARTNER_ID] andDelegate:self];
#endif
}


#pragma mark -
#pragma mark CleanUp

-(void)cleanUp
{
    self.partnerSections = nil;
    [sectionImagesDictionary release];
    _currentSectionName = nil;
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload {
    [self cleanUp];
    [activityIndicator release];
    activityIndicator = nil;
    
    [self setPartnersTableView:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [self cleanUp];
    [activityIndicator release];
    [_partnersTableView release];
    [super dealloc];
}
@end
