//
//  ViewController.m
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "AppActionsHelper.h"
#import "Reachability.h"
#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "Section.h"
#import "MasterDetailController.h"
#import "PartnerCell.h"
#import "PartnerViewController.h"
#import "UISearchBar+Customize.h"
#import "UITableViewCell+Spinner.h"
#import "UIButton+Extensions.h"

@interface SearchViewController()
- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset;
- (void) loadNearbyPartners;
- (void) partnersLoaded:(NSArray *)partners;
@end

@implementation SearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.accessibilityLabel = @"Search";
    [self.searchBar customizeSearchBar];
    selectedPartnerSections = nil;
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"searchBg"]]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:186.0f/255.0f green:186.0f/255.0f blue:186.0f/255.0f alpha:0.7f];
    self.partnersList = [NSMutableArray array];
    loadingMorePartnersInProgress = NO;
    [self searchForPartnersWithQuery:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    self.navigationItem.hidesBackButton = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) menuSectionTapped:(Section *) section
{
    [[RequestHelper sharedInstance] setCurrentSection:section];
    SubMenuViewController *subMenu = [SubMenuViewController new];
    subMenu.partner = defaultPartner;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:subMenu animated:YES];
    UIBarButtonItem *menuButton = [[AppActionsHelper sharedInstance]
                                   menuButtonWithTarget:self.masterDetail
                                   action:@selector(toggleMasterView)];
    subMenu.navigationItem.leftBarButtonItem = menuButton;
    [(TownWizardNavigationBar *)[self.navigationController navigationBar] updateTitleText:section.displayName];
    [self.masterDetail toggleMasterView];
    [subMenu release];    
}

-(void)infoButtonPressed:(id)sender
{
    if(defaultPartner)
    {
        [self.masterDetail toggleMasterView];
    }
}

- (void) changePartnerButtonTapped
{
    [self.masterDetail toggleMasterView];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)removeSpinnerFromCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cellWithSpinner = [self.tableView cellForRowAtIndexPath:indexPath];
    [cellWithSpinner removeSpinnerFromCell];
}
//do not use this method in tableView cellAtIndexPath method, cause cellForRowAtIndexPath return nil there
- (void)addSpinnerToCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell addSpinnerToCell];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout id *)mappableData
{
    NSMutableDictionary* data = [[*mappableData objectForKey: @"meta"] mutableCopy];
    if([data objectForKey:@"next_offset"])
    {
        nextOffset = [[data objectForKey:@"next_offset"] integerValue];
    }
    else
    {
        nextOffset = 0;
    }
    [data release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (objects)
    {
        [self partnersLoaded:objects];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void) searchForPartnersWithQuery:(NSString *)query
{
    [self searchForPartnersWithQuery:query offset:0];
}

- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset
{
    currentSearchQuery = query;
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    [RequestHelper partnersWithQuery:query offset:offset andDelegate:self];
    loadingMorePartnersInProgress = NO;
    if ([_partnersList count])
    {
        loadingMorePartnersInProgress = YES;
    }
}

- (void)partnersLoaded:(NSArray *)partners
{
    if ([partners count] == 0)
    {
        [UIAlertView showWithTitle:@"Whoops!"
                           message:@"Sorry, but it looks like we dont have a TownWizard in your area yet!"
                          delegate:self
                 cancelButtonTitle:@"OK"
                confirmButtonTitle:nil];       
        
    }
    else if([[partners lastObject] isKindOfClass:[Partner class]])
    {
        Partner *partner = [partners lastObject];
        if(partner && [partner.name isEqualToString:DEFAULT_PARTNER_NAME]
           && [currentSearchQuery isEqualToString:DEFAULT_PARTNER_NAME])
        {
            defaultPartner = [partner retain];
            [self.defaultMenu updateWithPartner:defaultPartner];
            // [self loadNearbyPartners];
        }
        else if(partners.count > 0 && loadingMorePartnersInProgress)
        {
            [_partnersList addObjectsFromArray:partners];
            loadingMorePartnersInProgress = NO;
        }
        else
        {
            _partnersList = [[NSMutableArray alloc]initWithArray:partners];
            if (defaultPartner == nil)
            {
                [self searchForPartnersWithQuery:DEFAULT_PARTNER_NAME];
            }
        }
    }
    [self.tableView reloadData];
    [self.goButton setEnabled:YES];
    [self.goButton removeSpinner];
}

- (void)loadNearbyPartners
{
    [self searchForPartnersWithQuery:nil];    
}

- (void)loadSectionMenuForPartnerWithPartner:(Partner *)aPartner
{
    PartnerViewController *controller = [[PartnerViewController alloc] initWithPartner:aPartner];
    [[self navigationController] pushViewController:controller animated:YES];
    [controller release];
}

-(void)locationManager:(CLLocationManager *)aManager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [aManager stopUpdatingLocation];
    [self loadNearbyPartners];
    
}

#pragma mark - TableView delegate mathods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (nextOffset == 0) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![_partnersList count]) return 0;
    
    if (section ==0) //Partners section
        return [_partnersList count];
    
    else return 1; // Load more section
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        Partner *partner = [_partnersList objectAtIndex:indexPath.row];
        [self.searchBar resignFirstResponder];
        
        if ([partner.iTunesAppId isEqual:@""])
        {
            [self loadSectionMenuForPartnerWithPartner:partner];
            
            if (partner.facebookAppId)
            {
                [AppDelegate sharedDelegate].facebookHelper.appId = partner.facebookAppId;
                [TestFlight passCheckpoint:@"facebook app id is set"];
            }
            else {
                [AppDelegate sharedDelegate].facebookHelper.appId = @"";
                [TestFlight passCheckpoint:@"Facebook app id is empty"];
            }
        }
        else
        {
            NSString * iTunesAppUrl = [[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id"]
                                       stringByAppendingString:
                                       partner.iTunesAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesAppUrl]];
        }
    }
    else if (indexPath.section == 1) //Load more button
    {
        [self addSpinnerToCellAtIndexPath:indexPath];
        loadingMorePartnersInProgress = YES;
        [self searchForPartnersWithQuery:currentSearchQuery offset:nextOffset];
    }
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell;    
    if (indexPath.section == 0)
    {
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[[PartnerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        }
        Partner *partner = [_partnersList objectAtIndex:indexPath.row];
        cell.textLabel.text = partner.name;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    else if (indexPath.section == 1)
    {
        cell = [aTableView dequeueReusableCellWithIdentifier:nil];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:nil] autorelease];
        }
        
        if (loadingMorePartnersInProgress)
        {
            cell.textLabel.text = @"";
            [cell addSpinnerToCell];
        }
        else
        {
            [self removeSpinnerFromCellAtIndexPath:indexPath];
            cell.textLabel.text = @"Load more";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }    
    return  cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (IBAction)dismissKeyboardByTouchingEmptySpaceOnScreen:(id)sender
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - UIsearchBar delegate mathods

- (IBAction)goButtonPressed:(id)sender
{
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
    if([[AppActionsHelper sharedInstance] townWizardServerReachable])
    {
        [self.goButton setEnabled:NO];
        [self.goButton addSpinner];
        [self.goButton setTitle:@"" forState:UIControlStateNormal];
        [self removeSpinnerFromCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if([_partnersList count] > 0)
        {
            [_partnersList removeAllObjects];
            [self.tableView reloadData];
        }
        NSString *query = aSearchBar.text;
        if ([query isEqual:@""])
        {
            query = nil;
        }      
        [self searchForPartnersWithQuery:query];
        currentSearchQuery = aSearchBar.text;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No connection available!", @"AlertView")
                                  message:NSLocalizedString(@"Please connect to cellular network or Wi-Fi", @"AlertView")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                  otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
        [alertView show];
        [alertView release];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [_partnersList release];
    [[UIApplication sharedApplication] setActivityindicatorToZero];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [_partnersList release];
    [[UIApplication sharedApplication] setActivityindicatorToZero];
    [super dealloc];
}

@end
