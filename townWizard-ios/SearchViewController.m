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
#import "AppDelegate.h"
#import "Section.h"
#import "MasterDetailController.h"
#import "PartnerCell.h"
#import "PartnerViewController.h"
#import "UISearchBar+Customize.h"
#import "UITableViewCell+Spinner.h"
#import "UIButton+Extensions.h"
#import "UIBarButtonItem+TWButtons.h"
#import "SearchHelper.h"

@interface SearchViewController()
- (void) configureViews;
@end

@implementation SearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchHelper = [[SearchHelper alloc] initWithDelegate:self];
    self.searchBar.accessibilityLabel = @"Search";
    [self configureViews];
    selectedPartnerSections = nil;
    [searchHelper loadNearbyPartners];
}

- (void)configureViews
{
    [self.searchBar customizeSearchBar];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:
                                        [UIImage imageNamed:@"searchBg"]]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:186.0f/255.0f
                                                    green:186.0f/255.0f
                                                     blue:186.0f/255.0f
                                                    alpha:0.7f];
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
    subMenu.partner = searchHelper.defaultPartner;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:subMenu animated:YES];
    UIBarButtonItem *menuButton = [UIBarButtonItem
                                   menuButtonWithTarget:self.masterDetail
                                   action:@selector(toggleMasterView)];
    subMenu.navigationItem.leftBarButtonItem = menuButton;
    [(TownWizardNavigationBar *)[self.navigationController navigationBar]
     updateTitleText:section.displayName];
    [self.masterDetail toggleMasterView];
    [subMenu release];
}

-(void)infoButtonPressed:(id)sender
{
    if(searchHelper.defaultPartner)
    {
        [self.masterDetail toggleMasterView];
    }
}

- (void) changePartnerButtonTapped
{
    [self.masterDetail toggleMasterView];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - SearchHelper delegate mathods

- (void)partnersLoaded:(NSArray *)partners
{
    [self.tableView reloadData];
    [self.goButton setEnabled:YES];
    [self.goButton removeSpinner];
}
- (void)defaultPartnerLoaded:(Partner *)defaultPartner
{
     [self.defaultMenu updateWithPartner:defaultPartner];
}

#pragma mark - TableView delegate mathods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searchHelper.nextOffset == 0)
    {
        return 1;
    }    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if (section == 0)
    {
        return [searchHelper.partnersList count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"Cell";
        
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[[PartnerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        }
        Partner *partner = [searchHelper.partnersList objectAtIndex:indexPath.row];
        cell.textLabel.text = partner.name;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"loadMoreCell";
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell removeSpinnerFromCell];
        cell.textLabel.text = @"Load more";
        
        if (searchHelper.loadingMorePartnersInProgress)
        {
            cell.textLabel.text = @"";
            [cell addSpinnerToCell];
        }
    }
    return  cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        Partner *partner = [searchHelper.partnersList objectAtIndex:indexPath.row];
        [self partnerSelected:partner];
    }
    else if (indexPath.section == 1) //Load more button
    {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell addSpinnerToCell];
        [searchHelper loadMorePartners];
    }
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)partnerSelected:(Partner *)partner
{
    if ([partner.iTunesAppId isEqual:@""] || ![partner.iTunesAppId hasPrefix:@"store"])
    {
        if (!partner.facebookAppId)
        {
            partner.facebookAppId = @"";
        }
        [AppDelegate sharedDelegate].facebookHelper.appId = partner.facebookAppId;
        PartnerViewController *controller = [[PartnerViewController alloc] initWithPartner:partner];
        [[self navigationController] pushViewController:controller animated:YES];
        [controller release];
    }
    else if([partner.iTunesAppId hasPrefix:@"store"])
    {
        partner.iTunesAppId = [partner.iTunesAppId stringByReplacingOccurrencesOfString:@"store"
                                                                             withString:@""];
        NSString * iTunesAppUrl = [[NSString stringWithFormat: @"http://itunes.apple.com/us/app/id"]
                                   stringByAppendingString:partner.iTunesAppId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesAppUrl]];
    }    
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
        [searchHelper searchForPartnersWithQuery:aSearchBar.text];
        [self.tableView reloadData];
    }
    else
    {
        [[AppActionsHelper sharedInstance] showNoInternetAlert];       
    }
}

- (void)cleanUp
{
    [searchHelper release];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload
{
    [self cleanUp];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self cleanUp];
    [super dealloc];
}

@end
