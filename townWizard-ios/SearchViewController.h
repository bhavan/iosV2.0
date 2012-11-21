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
@class TownWizardNavigationBar;
@class Partner;

@interface SearchViewController : UIViewController 
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,
PartnerMenuDelegate,SubMenuViewControllerDelegate,UIAlertViewDelegate, RKObjectLoaderDelegate, PartnerMenuDelegate>
{
    NSMutableArray *partnersList;
    NSArray *selectedPartnerSections;
   
    UISearchBar *searchBar;
    UITableView *tableView;
    UIImageView * logo;
    NSInteger nextOffset; // add offset to query to load more partners. ex: &offset=...
    BOOL loadingMorePartnersInProgress;
    Partner *defaultPartner;
    
}
- (UIBarButtonItem *) menuButton;
- (IBAction) goButtonPressed:(id)sender;
- (void) loadSectionMenuForPartnerWithPartner:(Partner *)partnerDict;

@property (nonatomic, retain) NSMutableArray *partnersList;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView * logo;
@property (nonatomic, retain) IBOutlet UIButton * goButton;
@property (nonatomic, retain) NSString * currentSearchQuery;
@property (nonatomic, retain) MasterDetailController *masterDetail;
@property (nonatomic, retain)  PartnerMenuViewController *defaultMenu;

-(BOOL)townWizardServerReachable;
-(IBAction)dismissKeyboardByTouchingEmptySpaceOnScreen:(id)sender;

-(IBAction)infoButtonPressed:(id)sender;
- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset;


@end
