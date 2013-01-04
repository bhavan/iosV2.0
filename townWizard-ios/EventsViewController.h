//
//  EventsViewController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>
#import "EventsViewer.h"
#import "GAITrackedViewController.h"
@class EventsViewer;


@interface EventsViewController : GAITrackedViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,
    EventViewerDelegate, RKObjectLoaderDelegate>
{    
    IBOutlet EventsViewer *featuredEventsViewer;
    IBOutlet UITableView *eventsList;
    NSInteger currentCategory;
}
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (retain, nonatomic) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) NSArray *categotiesList;
@property (retain, nonatomic) IBOutlet UIButton *eventsTypeButton;

- (IBAction)bannerButtonPressed:(id)sender;
- (IBAction)categoriesButtonPressed:(id)sender;
- (IBAction)dateSelectButtonPressed:(id)sender;

@end
