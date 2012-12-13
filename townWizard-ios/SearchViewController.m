//
//  ViewController.m
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "RequestHelper.h"
#import "Reachability.h"
#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "Section.h"
#import "UIImageView+WebCache.h"
#import "MasterDetailController.h"

#import "PartnerViewController.h"

@interface SearchViewController()
@property (nonatomic,assign) BOOL doNotUseGeopositionSearchResults;
@end

@implementation SearchViewController

@synthesize doNotUseGeopositionSearchResults;


-(NSString *)currentSearchQuery {
    if (!_currentSearchQuery)
        _currentSearchQuery = @"";
    return _currentSearchQuery;
}

#pragma mark -
#pragma mark NSUserDefaults saving

#define LOGO_PORTRAIT_WIDTH 320
#define LOGO_PORTRAIT_HEIGHT 110
#define NAVIGATION_BAR_HEIGHT 60

#pragma mark - Info

#define INFO_URL @"http://www.townwizard.com/app-info"

-(void)infoButtonPressed:(id)sender
{
    if(defaultPartner)
    {
        [self.masterDetail toggleMasterView];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];  
    self.searchBar.accessibilityLabel = @"Search";
    selectedPartnerSections = nil;
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
    UIImage * aLogo = [UIImage imageNamed:@"twHeader"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:aLogo];
    self.logo = imageView;
    [imageView release];
    
    self.logo.frame = CGRectMake(0,0, LOGO_PORTRAIT_WIDTH, LOGO_PORTRAIT_HEIGHT);
    [self.view addSubview:self.logo];
    self.tableView.separatorColor = [UIColor colorWithRed:0.792 green:0.769 blue:0.678 alpha:1];    
    self.partnersList = [[NSMutableArray alloc] init];
    doNotUseGeopositionSearchResults = NO;
    loadingMorePartnersInProgress = NO;
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //  [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
   // [self.navigationController.navigationBar addSubview:customNavigationBar];
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
    subMenu.navigationItem.leftBarButtonItem = [self menuButton];
      [(TownWizardNavigationBar *)[self.navigationController navigationBar] updateTitleText:[section name]];
    [self.masterDetail toggleMasterView];
    [subMenu release];
    
}
- (void) changePartnerButtonTapped
{
    [self.masterDetail toggleMasterView];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (UIBarButtonItem *) menuButton // refactoring!
{
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu_button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:menuButtonImage forState:UIControlStateNormal];
    [button addTarget:self.masterDetail action:@selector(toggleMasterView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


#pragma mark -
#pragma mark Spinner methods

#define SPINNER_SIZE 25

-(void)removeSpinnerFromCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cellWithSpinner = [self.tableView cellForRowAtIndexPath:indexPath];
    for (UIView * view in cellWithSpinner.contentView.subviews)
    {
        if ([view isKindOfClass:[UIActivityIndicatorView class]])
            [view removeFromSuperview];
    }
}

-(void)addSpinnerToCell:(UITableViewCell *)cell
{
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize cellSize = cell.frame.size;
    spinner.frame = CGRectMake(cellSize.width/2-SPINNER_SIZE/2, cellSize.height/2 - SPINNER_SIZE/2,
                               SPINNER_SIZE, SPINNER_SIZE);
    
    cell.textLabel.text = nil;
    [cell.contentView  addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
}

//do not use this method in tableView cellAtIndexPath method, cause cellForRowAtIndexPath return nil there
-(void)addSpinnerToCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self addSpinnerToCell:cell];
}


-(void)addSpinnerToButton:(UIButton *)button
{
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize buttonSize = button.frame.size;
    spinner.frame = CGRectMake(buttonSize.width/2-SPINNER_SIZE/2, buttonSize.height/2 - SPINNER_SIZE/2,
                               SPINNER_SIZE, SPINNER_SIZE);
    [button addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
}

-(void)removeSpinnerFromButton:(UIButton *)button
{
    for (UIView * view in button.subviews)
    {
        if ([view isKindOfClass:[UIActivityIndicatorView class]])
            [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

/*- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout id *)mappableData {
    NSMutableDictionary* data = [[*mappableData objectForKey: @"meta"] mutableCopy];
    if([data objectForKey:@"next_offset"]) {
        nextOffset = [[data objectForKey:@"next_offset"] integerValue];
    }
    else
    {
        nextOffset = 0;
    }
    [data release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (objects) {
        if ([objects count] == 0) {
            UIAlertView *alert = [[[UIAlertView alloc]
                                   initWithTitle:@"Whoops!"
                                   message:@"Sorry, but it looks like we dont have a TownWizard in your area yet!"
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] autorelease];
            [alert show];
            
        }
        else if([[objects lastObject] isKindOfClass:[Partner class]]) {
            Partner *partner = [objects lastObject];
            if(partner && [partner.name isEqualToString:DEFAULT_PARTNER_NAME])
            {
                if (!doNotUseGeopositionSearchResults)
                {
                    doNotUseGeopositionSearchResults = YES;
                    [self searchForPartnersWithQuery:nil];
                }
                
                defaultPartner = [partner retain];
                [self.defaultMenu updateWithPartner:defaultPartner];
            }
            else if(objects.count > 0 && loadingMorePartnersInProgress)
            {
                [_partnersList addObjectsFromArray:objects];
                loadingMorePartnersInProgress = NO;
            }
            else{
                _partnersList = [[NSMutableArray alloc]initWithArray:objects];
            }            
        }
        [self.tableView reloadData];
        [self.goButton setEnabled:YES];
        [self removeSpinnerFromButton:self.goButton];
        [self.goButton setTitle:@"GO" forState:UIControlStateNormal];
//        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
        
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}*/

#pragma mark -
#pragma mark PartnerMethods

-(BOOL)townWizardServerReachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"townwizard.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (void) searchForPartnersWithQuery:(NSString *)query {
    [self searchForPartnersWithQuery:query offset:0];
}

- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    
    [RequestHelper partnersWithQuery:query offset:offset UsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects) {
            [self partnersLoaded:objects];
        }];
    }];
    loadingMorePartnersInProgress = NO;
    if ([_partnersList count])
    {
        loadingMorePartnersInProgress = YES;
    }
}

- (void)partnersLoaded:(NSArray *)partners
{
    if ([partners count] == 0) {
        UIAlertView *alert = [[[UIAlertView alloc]
                               initWithTitle:@"Whoops!"
                               message:@"Sorry, but it looks like we dont have a TownWizard in your area yet!"
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] autorelease];
        [alert show];
        
    }
    else if([[partners lastObject] isKindOfClass:[Partner class]]) {
        Partner *partner = [partners lastObject];
        if(partner && [partner.name isEqualToString:DEFAULT_PARTNER_NAME])
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
        else{
            _partnersList = [[NSMutableArray alloc]initWithArray:partners];
            if (defaultPartner == nil) {
                [self searchForPartnersWithQuery:DEFAULT_PARTNER_NAME];
            }
        }
    }
    [self.tableView reloadData];
    [self.goButton setEnabled:YES];
    [self removeSpinnerFromButton:self.goButton];
    [self.goButton setTitle:@"GO" forState:UIControlStateNormal];

}

- (void)loadNearbyPartners
{
    if (!doNotUseGeopositionSearchResults)
    {
        doNotUseGeopositionSearchResults = YES;
        [self searchForPartnersWithQuery:nil];
    }

}


- (void)loadSectionMenuForPartnerWithPartner:(Partner *)aPartner {
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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Partner *partner = [_partnersList objectAtIndex:indexPath.row];
        
        [self.searchBar resignFirstResponder];
        
        if ([partner.iTunesAppId isEqual:@""]) {
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
        [self searchForPartnersWithQuery:self.currentSearchQuery offset:nextOffset];
    }
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //static NSString * CellMoreIdentifier = @"Cell more";
    UITableViewCell * cell;
    
    if (indexPath.section) { // Load more cell
        cell = [aTableView dequeueReusableCellWithIdentifier:nil];//CellMoreIdentifier];
        if(cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:nil]//CellMoreIdentifier]
                    autorelease];
        }
        if (loadingMorePartnersInProgress)
        {
            cell.textLabel.text = @"";
            [self addSpinnerToCell:cell];
        }
        else {
            [self removeSpinnerFromCellAtIndexPath:indexPath];
            cell.textLabel.text = @"Load more";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else { //Partner cell
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier]
                    autorelease];
        }
        Partner *partner = [_partnersList objectAtIndex:indexPath.row];
        cell.textLabel.text = partner.name;
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.308 green:0.2745 blue:0.227 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    
    [aSearchBar resignFirstResponder];
    if([self townWizardServerReachable]) {
        [self.goButton setEnabled:NO];
        [self addSpinnerToButton:self.goButton];
        [self.goButton setTitle:@"" forState:UIControlStateNormal];
        [self removeSpinnerFromCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if([_partnersList count] > 0)
        {
            [_partnersList removeAllObjects];
            [self.tableView reloadData];
        }
        doNotUseGeopositionSearchResults = YES;
        if ([aSearchBar.text isEqual:@""])
        {
            [self searchForPartnersWithQuery:nil];
        }
        else {
            [self searchForPartnersWithQuery:aSearchBar.text];
        }
        
        self.currentSearchQuery = aSearchBar.text;
    }
    else { //No connection
        [TestFlight passCheckpoint:@"No connection available while loading partners"];
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


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    doNotUseGeopositionSearchResults = YES;
}

- (IBAction)goButtonPressed:(id)sender {
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark -releaseOutlets
#pragma  mark cleaning

-(void)releaseOutlets
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setLogo:nil];
    [_partnersList release];
    self.currentSearchQuery = nil;
    
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload
{
    [self releaseOutlets];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self releaseOutlets];
    [super dealloc];
}


@end
