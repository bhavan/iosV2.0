//
//  VideosViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>

@class Partner;
@class Section;
@class TownWizardNavigationBar;

@interface VideosViewController : UIViewController  {
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Section *section;

@end
