//
//  PhotoCategoriesViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>


@class Partner;
@class TownWizardNavigationBar;

@interface PhotoCategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>
{
    NSArray *categories;
    Partner *partner;
}

@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, retain) NSArray *categories;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Partner *partner;

@end
