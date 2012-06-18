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
	
	IBOutlet MKMapView *m_mapView;
	IBOutlet UIActivityIndicatorView *m_activityIndicator;
	MKCoordinateRegion m_currentRegion;
	
	NSString *m_sTitle;
	double m_dblLatitude;
	double m_dblLongitude;
	IBOutlet UIButton *m_DirectionBtn;
	BOOL bShowDirection;
    MapAnnotation *placeMarker;
}

@property (nonatomic, retain) NSString *m_sTitle;
@property (nonatomic, assign) double m_dblLatitude;
@property (nonatomic, assign) double m_dblLongitude;
@property (nonatomic, assign) BOOL bShowDirection;
@property (nonatomic, retain) MapAnnotation *placeMarker;

@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;

- (void)loadGoogleMap;
- (IBAction)directionBtnClicked:(id)sender;

@end
