//
//  VideosViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import <GAITrackedViewController.h>

@class Partner;
@class Section;

@interface VideosListViewController : GAITrackedViewController

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) Section *section;

@end
