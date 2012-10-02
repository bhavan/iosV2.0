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

@class TownWizardNavigationBar;
@class Partner;

@interface ViewController : UIViewController 
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,
PartnerMenuViewControllerDelegate,SubMenuViewControllerDelegate,UIAlertViewDelegate, RKObjectLoaderDelegate>
{
    NSMutableArray *partnersList;
    NSArray *selectedPartnerSections;
    TownWizardNavigationBar *customNavigationBar;
    PartnerMenuViewController *selectedMenu;
    UISearchBar *searchBar;
    NSInteger nextOffset; // add offset to query to load more partners. ex: &offset=...
    BOOL loadingMorePartnersInProgress;
}
- (IBAction) goButtonPressed:(id)sender;
- (void) loadSectionMenuForPartnerWithPartner:(Partner *)partnerDict;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIImageView * logo;
@property (nonatomic,retain) IBOutlet UIButton * goButton;
@property (nonatomic,retain) NSString * currentSearchQuery;

-(BOOL)townWizardServerReachable;
-(IBAction)dismissKeyboardByTouchingEmptySpaceOnScreen:(id)sender;

-(IBAction)infoButtonPressed:(id)sender;


@end
