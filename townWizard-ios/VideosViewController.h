//
//  VideosViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import "SectionController.h"

@class Partner;
@class Section;
@class TownWizardNavigationBar;

@interface VideosViewController : UIViewController <SectionController, RKObjectLoaderDelegate>
{
    NSArray *videos;
}
@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, retain) Partner *partner;
@property (nonatomic, retain) Section *section;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
