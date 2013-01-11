//
//  MapViewController.m
//  30A
//
//  Created by vivek  mangal on 09/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "MapAnnotation.h"


@implementation MapViewController

@synthesize placeMarker;

- (id) init {
	self = [self initWithNibName:@"MapViewController" bundle:nil];
	return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:NO];
	if(bShowDirection == NO)
    {
		directionButton.hidden = YES;
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self loadGoogleMap];
}

- (void)menuButtonPressed
{
    //UIViewController *menuViewController = self.customNavigationBar.menuPage;
    //[self.navigationController popToViewController:menuViewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -

- (IBAction)directionBtnClicked:(id)sender
{
    [UIAlertView showWithTitle:@"Directions"
                       message:
     @"To give you better directions,\nthe application will close.\nDo you wish to continue?"
                      delegate:self
             cancelButtonTitle:@"Yes"
            confirmButtonTitle:@"No"];
		
}

- (void)loadGoogleMap
{
	currentRegion.center.latitude = latitude;
	currentRegion.center.longitude = longitude;
	
	currentRegion.span.latitudeDelta = 0.009;
	currentRegion.span.longitudeDelta = 0.009;
	
	[mapView setRegion:currentRegion animated:YES];
	
	// Load all the markers for this location
	[activityIndicator startAnimating];
	[NSThread detachNewThreadSelector:@selector(loadMarkers) toTarget:self withObject:nil];
}

- (void)loadMarkers
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];	

	NSMutableArray* annots = [[NSMutableArray alloc] init];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	CLLocationCoordinate2D currentLocation;
	currentLocation.latitude = appDelegate.doubleLatitude;
	currentLocation.longitude = appDelegate.doubleLongitude;
	
	MapAnnotation* user_marker = [[MapAnnotation alloc] initWithCoordinate:currentLocation 
                                                                     title:@"You" 
                                                            annotationType:MapAnnotationTypePin];
	[annots addObject:user_marker];
	[user_marker release];	

	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
	
	// Add markers
	MapAnnotation* place_marker = [[MapAnnotation alloc] initWithCoordinate:location 
                                                                      title:self.topTitle
                                                             annotationType:MapAnnotationTypePin];
	//[place_marker setSelected:YES animated:NO];
	[annots addObject:place_marker];
    self.placeMarker = place_marker;
	[place_marker release];
	
	[(id)mapView performSelectorOnMainThread:@selector(addAnnotations:) 
                                    withObject:annots 
                                 waitUntilDone:YES];
	[activityIndicator stopAnimating];
		
	[annots release];
	[pool release];
}


#pragma mark -
#pragma mark MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSString *sIdentifier = @"MapPin";
	MKPinAnnotationView* annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:sIdentifier];
	
	if(annotationView == nil)
	{
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                          reuseIdentifier:sIdentifier] autorelease];
	}
	
	NSString *sTitle = ((MapAnnotation *)annotation).title;
	if([sTitle isEqualToString:@"You"]) 
	{
		[annotationView setPinColor:MKPinAnnotationColorRed];
	}
	else
	{
		[annotationView setPinColor:MKPinAnnotationColorPurple];
	}
	annotationView.animatesDrop = YES;
	
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];	
	
	return annotationView;
}

- (void)mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
	[aMapView selectAnnotation:self.placeMarker animated:YES];
}

#pragma mark 
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		NSString *sUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%.4f,%.4f&saddr=%.4f,%.4f", 
                          self.latitude, self.longitude,
                          appDelegate.doubleLatitude, appDelegate.doubleLongitude];

		[[UIApplication sharedApplication ] openURL:[NSURL URLWithString: sUrl]];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[mapView release];
	[activityIndicator release];
    [super dealloc];
}

#pragma mark -

@synthesize latitude;
@synthesize longitude;
@synthesize bShowDirection;
@end
