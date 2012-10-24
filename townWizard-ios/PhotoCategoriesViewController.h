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
@class Section;

@interface PhotoCategoriesViewController : BaseUploadViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>
{
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain, readonly) NSArray *categories;

@end
