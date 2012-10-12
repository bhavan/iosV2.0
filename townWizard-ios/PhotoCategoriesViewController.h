//
//  PhotoCategoriesViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseUploadViewController.h"


@class Partner;
@class TownWizardNavigationBar;


@interface PhotoCategoriesViewController : BaseUploadViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>
{
    NSArray *categories;


}

@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, retain) NSArray *categories;
@property (retain, nonatomic) IBOutlet UITableView *tableView;



@end
