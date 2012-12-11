//
//  FacebookPlacesViewController.h
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacebookPlacesViewCell.h"
#import "Place.h"
#import "FacebookHelper.h"
#import "DataHolder.h"
#import "townWIzardNavigationBar.h"
#import <CoreLocation/CoreLocation.h>
#import "SDWebImageDownloader.h"

typedef enum {
    FB_PLACES_REQUEST_PLACES,
} FBPlacesRequestIndex;

@interface FacebookPlacesViewController : UIViewController <FacebookHelperDelegate, FBRequestDelegate,
UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,FBSessionDelegate> {
    
    double latitude;
    double longitude;
        
	NSMutableArray *places;
	UIViewController *parent;
    UITableView *tableView;
    
    Place *selectedPlace;
    FacebookHelper *facebookHelper;
    FBPlacesRequestIndex currentRequest;
    
    BOOL locationUpdated;
    
    BOOL showsExtendedInfo;
}

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) PlaceInfo *placeInfo;
@property (nonatomic,retain) NSMutableArray *places;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;


- (id) initWithPlaces:(NSMutableArray *)thePlaces;
- (id) initWithPlace:(PlaceInfo *)place;
- (id) initWithLatitude:(double)aLatitude andLongitude:(double)aLongitude;

- (void) checkIn:(Place *)place;
- (void) parseResponseToPlaces:(NSData *)data;

@end
