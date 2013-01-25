//
//  FacebookPlacesViewController.m
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookPlacesViewController.h"
#import "Place.h"
#import "FacebookCheckinViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"

@implementation FacebookPlacesViewController

@synthesize latitude;
@synthesize longitude;
@synthesize tableView=_tableView;
@synthesize placeInfo;
@synthesize places;
@synthesize parent;


#pragma mark -
#pragma mark initializers

- (void) initController {
    facebookHelper = [AppDelegate sharedDelegate].facebookHelper;
}

- (id) initWithPlaces:(NSMutableArray *)thePlaces {
    self = [super init];
	if(self){
		self.places = thePlaces;
        [self initController];
	}
	return self;
}

- (id) initWithPlace:(PlaceInfo *)place {
    return [self initWithLatitude:place.dblLatitude andLongitude:place.dblLongitude];
}

- (id) init {
    if ([CLLocationManager locationServicesEnabled])
        return [self initWithLatitude:[AppDelegate sharedDelegate].doubleLatitude
                         andLongitude:[AppDelegate sharedDelegate].doubleLongitude];
    else // Location services disabled
        return [self initWithLatitude:0
                         andLongitude:0];
}

- (id) initWithLatitude:(double)aLatitude andLongitude:(double)aLongitude {
    self = [super init];
    if (self) {
        NSLog(@"Init with %lf, %lf", aLatitude, aLongitude);
        self.latitude = aLatitude;
        self.longitude = aLongitude;
        [self initController];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycles

- (void) viewDidLoad {
    [super viewDidLoad];
    
    showsExtendedInfo = YES; //setting this to NO removes additional info from Places cells
    //setting to YES causes a small leak, about 1kb each facebook check-in
    //more places appear = bigger leak
    
    //self.navigationItem.hidesBackButton = YES;
    CGRect bounds = self.view.bounds;
    
    UITableView * tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width,  bounds.size.height) style:UITableViewStylePlain];
    self.tableView = tv;
    self.tableView.backgroundColor = [UIColor clearColor];
    [tv release];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    self.tableView.accessibilityLabel = @"Check in here";
}

- (void)menuButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!places) {
        self.places = [NSMutableArray array];
        
        NSArray *permissions =  [NSArray arrayWithObjects:
                                 @"publish_stream",
                                 //@"read_stream",
                                 //@"offline_access",
                                 @"publish_checkins",
                                 @"friends_checkins", nil];
        [facebookHelper authorizePermissions:permissions for:self];
    }
    //        [self.customNavigationBar.menuButton addTarget:self
    //                                                action:@selector(menuButtonPressed)
    //                                      forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [self.customNavigationBar.menuButton removeTarget:self
    //                                               action:@selector(menuButtonPressed)
    //                                     forControlEvents:UIControlEventTouchUpInside];
    [[AppDelegate sharedDelegate].manager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}



#pragma mark -
#pragma mark loading places

// Query places near given place from Facebook
-(void) loadPlaces {
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
	NSString *center = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    center = [center stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"place",  @"type",
								   [facebookHelper.facebook accessToken], @"access_token",
								   center, @"center",
								   @"2000", @"distance",
                                   @"20", @"limit",
                                   @"name,category,location,picture,checkins", @"fields",
								   nil];
	
    currentRequest = FB_PLACES_REQUEST_PLACES;
	[facebookHelper.facebook requestWithGraphPath:@"search"
										andParams:params
									  andDelegate:self];
}

// Parse places request response
- (void) parseResponseToPlaces:(NSData*)data{
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSDictionary *json = [response objectFromJSONString];
	
	NSArray *parts = [json objectForKey:@"data"];
	NSDictionary * error = [json objectForKey:@"error"];
    
    if (error)
    {// we will force authorizing permission, and use delegate callback
        
        [TestFlight passCheckpoint:@"Some error, possibly permission revoked"];
        NSArray *permissions =  [NSArray arrayWithObjects:
                                 @"publish_stream",
                                 //@"read_stream",
                                 //@"offline_access",
                                 @"publish_checkins",
                                 @"friends_checkins", nil];
        [AppDelegate sharedDelegate].facebookHelper.delegate = self;
        
		[[AppDelegate sharedDelegate].facebookHelper.facebook
         authorize:[AppDelegate sharedDelegate].facebookHelper.appId
         permissions:permissions
         delegate:[AppDelegate sharedDelegate].facebookHelper];
        [response release];
        return;
    }
    if(parts.count==0)
    {
        UIAlertView *alert = [UIAlertView showWithTitle:@"Places in this location"
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:nil
                                     confirmButtonTitle:@"OK"];
        [alert setTag:1];
    }
    else
    {
        for(NSDictionary *part in parts){
            Place *p = [[Place alloc] init];
            p.name = [part valueForKey:@"name"];
            p.category = [part valueForKey:@"category"];
            
            NSDictionary *addressDict = [part valueForKey:@"location"];
            NSMutableString *address = [[NSMutableString alloc] init];
            if([addressDict valueForKey:@"city"]){
                [address appendFormat:@"%@", [addressDict valueForKey:@"city"]];
            }
            if([addressDict valueForKey:@"street"]){
                [address appendFormat:@"%@", ([address length] > 0 ?
                                              [NSString stringWithFormat:@", %@", [addressDict valueForKey:@"street"]] :
                                              [addressDict valueForKey:@"street"])];
            }
            NSString *imageUrl = [[[part objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
            p.imageUrl = imageUrl;
            
            p.latitude = [[addressDict valueForKey:@"latitude"] doubleValue];
            p.longitude = [[addressDict valueForKey:@"longitude"] doubleValue];
            p.address = address;
            p.place_id = [part valueForKey:@"id"];
            p.totalCheckins = [part valueForKey:@"checkins"];
            
            [address release];
            [places addObject:p];
            [p release];
        }
    }
	[response release];
}




// Check in place
- (void) checkIn:(Place *)place
{
    FacebookCheckinViewController *checkinController =
    [[FacebookCheckinViewController alloc] initWithSelectedPlace:selectedPlace];
    [self.navigationController pushViewController:checkinController animated:YES];
    [checkinController release];
}

#pragma mark - FacebookHelperDelegate

- (void) facebookPermissionGranted
{
    [TestFlight passCheckpoint:@"facebook permission granted"];
    locationUpdated = NO;
    [AppDelegate sharedDelegate].manager.delegate = self;
    if ([CLLocationManager locationServicesEnabled])
        //[[AppDelegate sharedDelegate].manager startUpdatingLocation];
        [self loadPlaces];
    else {
        [TestFlight passCheckpoint:@"Location services disabled"];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Location services disabled!", @"AlertView")
                                  message:NSLocalizedString(@"You can enable them in settings", @"AlertView")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                  otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
        alertView.tag = 1;
        [alertView show];
        [alertView release];
    }
    
}

-(void)locationManager:(CLLocationManager *)aManager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [aManager stopUpdatingLocation];
    /*  if (!locationUpdated)
     {
     locationUpdated = YES;
     self.latitude = newLocation.coordinate.latitude;
     self.longitude = newLocation.coordinate.longitude;
     [self loadPlaces];
     }*/
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [TestFlight passCheckpoint:@"Location manager changed authorization status"];
    if (status == kCLAuthorizationStatusAuthorized)
    {
        locationUpdated = NO;
        [manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        [TestFlight passCheckpoint:@"Location services for this device are disabled"];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Location services for this app are disabled!", @"AlertView")
                                  message:NSLocalizedString(@"You can enable them in settings", @"AlertView")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                  otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
        alertView.tag = 1;
        [alertView show];
        [alertView release];
        [manager stopUpdatingLocation];
    }
}

- (void) facebookPermissionNotGranted {
    [TestFlight passCheckpoint:@"facebook permission denied"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - FBRequest delegate

-(void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data{
    switch (currentRequest) {
        case FB_PLACES_REQUEST_PLACES:
            [places removeAllObjects];
            [self parseResponseToPlaces:data];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    self.tableView.hidden = NO;
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return showsExtendedInfo ? 100 : 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [places count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlacesCell";
    static NSString *CellNib = @"PlacesViewCell";
	
    FacebookPlacesViewCell *cell =
    (FacebookPlacesViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
     Place *place = [places objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (FacebookPlacesViewCell *)[nib objectAtIndex:0];
        
    }    
   
    [cell loadPlace:place withFacebook:facebookHelper.facebook extended:showsExtendedInfo];
    return cell;
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0) // Check in in selected place
    {
        if(buttonIndex == 1)
        {
            [self checkIn:selectedPlace];
        }
        else {
            NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
            [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
        }
    }
    else if (alertView.tag ==1) //Location services disabled
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        else
        {
            [self menuButtonPressed];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPlace = [places objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"CHECK IN"
                                                         message:[NSString stringWithFormat:
                                                                  @"Do you want to check in to '%@'?", selectedPlace.name]
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                               otherButtonTitles:@"Yes", nil];
    alertView.tag = 0;
    [alertView show];
    [alertView release];
}


#pragma mark -
#pragma mark Memory management

-(void)cleanUp
{
    self.placeInfo = nil;
    self.places = nil;
    self.tableView = nil;
    [[UIApplication sharedApplication] setActivityindicatorToZero];
    //    [self.customNavigationBar.menuButton removeTarget:self
    //                                               action:@selector(menuButtonPressed)
    //                                     forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidUnload {
    [self cleanUp];
    [super viewDidUnload];
}

- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}

#pragma mark -


@end

