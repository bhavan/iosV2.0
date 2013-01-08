//
//  MapViewController.h
//  30A
//
//  Created by vivek  mangal on 09/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapAnnotation.h"
#import <MapKit/MapKit.h>
#import "townWIzardNavigationBar.h"


@interface MapViewController : UIViewController <UIAlertViewDelegate> {
	
	IBOutlet MKMapView *mapView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	MKCoordinateRegion currentRegion;
	double latitude;
	double longitude;
	IBOutlet UIButton *directionButton;
	BOOL bShowDirection;
    MapAnnotation *placeMarker;
}

@property (nonatomic,retain) NSString *topTitle;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL bShowDirection;
@property (nonatomic, retain) MapAnnotation *placeMarker;

@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;

- (void)loadGoogleMap;
- (IBAction)directionBtnClicked:(id)sender;

@end
