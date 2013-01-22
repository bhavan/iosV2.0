//  ViewController.h
//  townWizard-ios
//
//  Created by admin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PartnerMenuViewController.h"
#import "SubMenuViewController.h"

@class MasterDetailController;
@class Partner;

@interface SearchViewController : UIViewController 
<UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource,
CLLocationManagerDelegate,
PartnerMenuDelegate,
SubMenuViewControllerDelegate,
UIAlertViewDelegate,
RKObjectLoaderDelegate>
{
    NSArray *selectedPartnerSections;   
    NSInteger nextOffset;
    NSString *currentSearchQuery;
    BOOL loadingMorePartnersInProgress;
    Partner *defaultPartner;
}

@property (nonatomic, retain) NSMutableArray *partnersList;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton * goButton;
@property (nonatomic, retain) MasterDetailController *masterDetail;
@property (nonatomic, retain) PartnerMenuViewController *defaultMenu;

- (IBAction)dismissKeyboardByTouchingEmptySpaceOnScreen:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;
- (IBAction) goButtonPressed:(id)sender;
- (void) partnerSelected:(Partner *)partnerDict;


@end
