//
//  ViewController.m
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RequestHelper.h"
#import "Reachability.h"
#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "AppDelegate.h"

@interface ViewController()
@property (nonatomic,assign) BOOL doNotUseGeopositionSearchResults;
@end

@implementation ViewController
@synthesize searchBar=_searchBar;
@synthesize tableView=_tableView;
@synthesize logo=_logo;
@synthesize goButton=_goButton;
@synthesize currentSearchQuery=_currentSearchQuery;
@synthesize doNotUseGeopositionSearchResults;


-(NSString *)currentSearchQuery {
    if (!_currentSearchQuery) 
        _currentSearchQuery = @"";
    return _currentSearchQuery;
}

#pragma mark -
#pragma mark NSUserDefaults saving

-(void)saveDefaultPartner:(NSDictionary*)partnerInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:partnerInfo 
                                              forKey:@"defaultPartner"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveSectionsForDefaultPartner:(NSArray *)sections
{
    [[NSUserDefaults standardUserDefaults] setObject:sections 
                                              forKey:@"partnerSections"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#define LOGO_PORTRAIT_WIDTH 320
#define LOGO_PORTRAIT_HEIGHT 110
#define NAVIGATION_BAR_HEIGHT 60

#pragma mark - Animations
-(void)animateLogoToScreen
{
    [UIView animateWithDuration:0.35 animations:^{
        self.logo.frame=CGRectMake(0, 0, LOGO_PORTRAIT_WIDTH, LOGO_PORTRAIT_HEIGHT);
    }];
}

-(void)animateLogoOffScreen
{
    [UIView animateWithDuration:0.35 animations:^{
        self.logo.frame = CGRectMake(-LOGO_PORTRAIT_WIDTH, 0, 
                                     LOGO_PORTRAIT_WIDTH, LOGO_PORTRAIT_HEIGHT);
    }];
}


-(void)animateNavigationBarOnScreen:(TownWizardNavigationBar *)bar
{        
        bar.frame = CGRectMake(self.view.frame.size.width, 0, 
                               self.view.frame.size.width, NAVIGATION_BAR_HEIGHT);
        
        [UIView animateWithDuration:0.35 animations:^{
            bar.frame = CGRectMake(0, 0, 
                                        self.view.frame.size.width, NAVIGATION_BAR_HEIGHT);
        }];
}

-(void)hideBackgroundImageOfTheNavigationBar:(TownWizardNavigationBar *)bar
{
    bar.backgroundImageView.frame = CGRectMake(0, -60, 320, 60);
}


#pragma mark - go Home

- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self animateLogoToScreen];
    
    [self saveDefaultPartner:nil];
}

-(void)menuButtonPressed:(id)sender
{
    [self goHome];
}

#pragma mark - Info

#define INFO_URL @"http://www.townwizard.com/app-info"

-(void)infoButtonPressed:(id)sender
{
    SubMenuViewController *subMenu=[[SubMenuViewController alloc] 
                                        initWithNibName:@"subMenuViewController" bundle:nil];
    subMenu.customNavigationBar = customNavigationBar;
    
    subMenu.delegate = self;
    subMenu.url = INFO_URL;
    
    [self.navigationController pushViewController:subMenu animated:YES];
        
    [self animateLogoOffScreen];
    [self hideBackgroundImageOfTheNavigationBar:subMenu.customNavigationBar];
    [self animateNavigationBarOnScreen:subMenu.customNavigationBar];
    
    [subMenu release];    
}

#pragma mark - View lifecycle

-(void)loadBackgroundForMenu:(PartnerMenuViewController *)menu
{
    if ([menu.partnerInfoDictionary objectForKey:@"image"]) {
        dispatch_queue_t downloadQueue = dispatch_queue_create("background downloader", NULL);
        
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",
                            SERVER_URL,[menu.partnerInfoDictionary objectForKey:@"image"]];
        
        dispatch_async(downloadQueue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl] 
                                                       options:(NSUInteger)nil 
                                                         error:nil];  
            if (imageData) {
                UIImage * background = [[UIImage alloc] initWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (menu.view.window) {
                        [menu.customNavigationBar.backgroundImageView setFrame:CGRectMake(0, -60, 320, 60)];
                        [menu.customNavigationBar.backgroundImageView setImage:background];
                        [UIView animateWithDuration:0.5 animations:^{
                            menu.customNavigationBar.backgroundImageView.frame = CGRectMake(0, 0, 320, 60);
                        }];
                    }
                });
                [background release];
            }
            dispatch_release(downloadQueue);
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];	
    self.searchBar.accessibilityLabel = @"Search";
    selectedPartnerSections = nil;
    for (UIView *subview in self.searchBar.subviews) {
       if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }        
    }    
    UIImage * logo = [UIImage imageNamed:@"twHeader.png"];
    UIImageView * iw = [[UIImageView alloc] initWithImage:logo];
    self.logo = iw;
    [iw release];
    
    self.logo.frame = CGRectMake(0,0, LOGO_PORTRAIT_WIDTH, LOGO_PORTRAIT_HEIGHT);
    [self.navigationController.navigationBar addSubview:self.logo];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.792 green:0.769 blue:0.678 alpha:1];
 
    partnersList = [[NSMutableArray alloc] init];
    customNavigationBar = [[TownWizardNavigationBar alloc] 
                           initWithFrame:CGRectMake(self.view.frame.size.width, 0, 
                                                    self.view.frame.size.width, NAVIGATION_BAR_HEIGHT)];
    
    [customNavigationBar.backButton addTarget:self 
                                       action:@selector(goHome) 
                             forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:customNavigationBar];
    
    NSDictionary * partnerDict = [[NSUserDefaults standardUserDefaults] 
                                                                    objectForKey:@"defaultPartner"];
    NSMutableArray * partnerSect = [[NSUserDefaults standardUserDefaults] 
                                                                    objectForKey:@"partnerSections"];
     
    doNotUseGeopositionSearchResults = NO;
    loadingMorePartnersInProgress = NO;
    
    if(partnerDict != nil && partnerSect != nil) {
        selectedPartnerSections = partnerSect;
        PartnerMenuViewController *subMenu = [[PartnerMenuViewController alloc] init];
        subMenu.customNavigationBar = customNavigationBar;
        subMenu.partnerInfoDictionary = partnerDict;
        
        if ([partnerDict objectForKey:@"facebook_app_id"]) 
        {
            [AppDelegate sharedDelegate].facebookHelper.appId = [partnerDict 
                                                                 objectForKey:@"facebook_app_id"];
        }
        subMenu.partnerSections = selectedPartnerSections;
        subMenu.delegate = self;
   
        customNavigationBar.menuPage = subMenu;
        [self.navigationController pushViewController:subMenu animated:NO];
        [self loadBackgroundForMenu:subMenu];
        [subMenu release];
        doNotUseGeopositionSearchResults = YES;
        
        //Animations are not needed, this is start of the application

            self.logo.frame = CGRectMake(-LOGO_PORTRAIT_WIDTH, 0, 
                                         LOGO_PORTRAIT_WIDTH, LOGO_PORTRAIT_HEIGHT);
            customNavigationBar.frame = CGRectMake(0, 0, 
                                                   self.view.frame.size.width, NAVIGATION_BAR_HEIGHT);
//        [self showMenuForPartner:partnerDict];
    }
}

- (void) showMenuForPartner:(NSDictionary *) partnerInfo {
    PartnerMenuViewController *controller = [[PartnerMenuViewController alloc] init];
    [controller setPartnerInfoDictionary:partnerInfo];
    [[self navigationController] pushViewController:controller animated:YES];
    [controller release];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    //  [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar addSubview:customNavigationBar];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    self.navigationItem.hidesBackButton = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    // If query is nil, then search will be by current geoposition 
    
    loadingMorePartnersInProgress = NO;
    //__block BOOL isLoadingMore = NO; 
    if ([partnersList count])
    {
        //isLoadingMore = YES;
        loadingMorePartnersInProgress = YES;
    }
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("Download Partners", NULL);
    dispatch_async(downloadQueue, ^{
        NSURLRequest*request;
        if (query) {
            request = [RequestHelper searchRequest:query];
        }
        else {
            request = [RequestHelper searchRequestUsingCurrentGeoposition];
        }
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        NSData *data = PerformURLRequest(request);
        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dict = (NSDictionary *)[parser objectWithData:data];
        
        //this can happen when user taps load more and before results came back, he taps on search
        //If that's the case, we do not need results that came from this download block
        if ((loadingMorePartnersInProgress && [partnersList count]) || (!loadingMorePartnersInProgress && ![partnersList count]))
        {
            [partnersList addObjectsFromArray:[dict objectForKey:@"data"]];
        
            NSDictionary * metadata = [[dict objectForKey:@"meta"] retain];
            nextOffset = [(NSNumber *) [metadata objectForKey:@"next_offset"] intValue];
            [metadata release];
            if([partnersList count]<=0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[[UIAlertView alloc] 
                                           initWithTitle:@"Whoops!" 
                                           message:@"Sorry, but it looks like we dont have a TownWizard in your area yet!" 
                                           delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil] autorelease];
                    [alert show];  
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeSpinnerFromCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];  
                loadingMorePartnersInProgress = NO;
                [self.tableView reloadData];
                [self.goButton setEnabled:YES];
                [self removeSpinnerFromButton:self.goButton];
                [self.goButton setTitle:@"GO" forState:UIControlStateNormal];
            });
        }
        [parser release];    
    });
    dispatch_release(downloadQueue);
}

-(void)LoadSectionsForSectionMenu:(PartnerMenuViewController *)menu
{
    dispatch_queue_t downloadSectionsQueue = dispatch_queue_create("Sections Download Queue", NULL);
    dispatch_async(downloadSectionsQueue, ^{
        NSURLRequest * request = [RequestHelper sectionsWithPartner:[menu.partnerInfoDictionary objectForKey:@"id"]];
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        NSData *data = PerformURLRequest(request);
        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        selectedPartnerSections = (NSArray *)[[parser objectWithData:data] objectForKey:@"data"];
        
        [self saveSectionsForDefaultPartner:selectedPartnerSections];
        
        menu.partnerSections = selectedPartnerSections;
        dispatch_async(dispatch_get_main_queue(), ^{
            [menu reloadMenu];
        });
        [menu release];
        [parser release];
    });
    dispatch_release(downloadSectionsQueue);
}

- (void)loadSectionMenuForPartnerWithInfo:(NSDictionary *)partnerDict {
    PartnerMenuViewController *subMenu = [[PartnerMenuViewController alloc] 
                                          initWithNibName:@"PartnerMenuViewController" 
                                                   bundle:nil];
    subMenu.customNavigationBar = customNavigationBar;
    subMenu.delegate = self; //This is for Menu button pressed there
    customNavigationBar.menuPage = subMenu;
    subMenu.partnerInfoDictionary = partnerDict;

    [self loadBackgroundForMenu:subMenu]; //asynchronous call

    [self.navigationController pushViewController:subMenu animated:YES];

    //transition animations
    [self animateLogoOffScreen];
    [self hideBackgroundImageOfTheNavigationBar:subMenu.customNavigationBar];
    [self animateNavigationBarOnScreen:subMenu.customNavigationBar];
    //------
    
//    [subMenu showSpinnerAtViewCenter:subMenu.view];
////submenu is released here:
    [self LoadSectionsForSectionMenu:subMenu]; //asynchronous call

}

-(void)locationManager:(CLLocationManager *)aManager 
   didUpdateToLocation:(CLLocation *)newLocation 
          fromLocation:(CLLocation *)oldLocation
{
    [aManager stopUpdatingLocation];

    if (!doNotUseGeopositionSearchResults) 
    {
        doNotUseGeopositionSearchResults = YES;
        [self searchForPartnersWithQuery:nil];
    }
}

#pragma mark - TableView delegate mathods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (nextOffset == 0) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![partnersList count]) return 0;
    
    if (section ==0) //Partners section
        return [partnersList count];
    
    else return 1; // Load more section
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *partnerDict = [partnersList objectAtIndex:indexPath.row];
     
        [self.searchBar resignFirstResponder];
        
        if ([[partnerDict objectForKey:@"itunes_app_id"] isEqual:@""]) {
            [self loadSectionMenuForPartnerWithInfo:partnerDict];
//            [self showMenuForPartner:partnerDict];
            [self saveDefaultPartner:partnerDict];
            if ([partnerDict objectForKey:@"facebook_app_id"]) 
            {
                [AppDelegate sharedDelegate].facebookHelper.appId = 
                                                    [partnerDict objectForKey:@"facebook_app_id"];
                [TestFlight passCheckpoint:@"facebook app id is set"];
            }
            else {
                [AppDelegate sharedDelegate].facebookHelper.appId = @"";
                [TestFlight passCheckpoint:@"Facebook app id is empty"];
            }
        }
        else
        {
            NSString * iTunesAppUrl =[[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id"] 
                                                stringByAppendingString:
                                                [partnerDict objectForKey:@"itunes_app_id"]]; 
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesAppUrl]];
        }
    }
    else if (indexPath.section ==1) //Load more button
    {
        [self addSpinnerToCellAtIndexPath:indexPath];
        loadingMorePartnersInProgress = YES;
        
        NSString * query = [NSString stringWithFormat:@"%@&offset=%d",self.currentSearchQuery,nextOffset];
        [self searchForPartnersWithQuery:query];
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
        cell.textLabel.text = [[partnersList objectAtIndex:indexPath.row] objectForKey:@"name"];
    }

    cell.textLabel.textColor = [UIColor colorWithRed:0.308 green:0.2745 blue:0.227 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return  cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

-(IBAction)dismissKeyboardByTouchingEmptySpaceOnScreen:(id)sender
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
        [partnersList removeAllObjects];
        [self.tableView reloadData];
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

#pragma mark -
#pragma  mark cleaning

-(void)releaseOutlets
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setLogo:nil];
    [partnersList release];
    self.currentSearchQuery = nil;
    
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload {
    [self releaseOutlets];
    [super viewDidUnload];    
}

- (void)dealloc {
    [self releaseOutlets];
    [super dealloc];
}



#pragma mark -
#pragma mark 

@end
