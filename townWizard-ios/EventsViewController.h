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
#import "EventsHelper.h"

@class EventsViewer;

@interface EventsViewController : GAITrackedViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,
    EventViewerDelegate,
    EventsHelperDelegate>
{
    EventsHelper *eventsHelper;
    IBOutlet EventsViewer *featuredEventsViewer;
    IBOutlet UITableView *eventsList;


}
@property (retain, nonatomic) IBOutlet UIView *tableHeader;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *bannerButton;
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (retain, nonatomic) IBOutlet UIButton *calendarButton;
@property (retain, nonatomic) IBOutlet UIButton *eventsTypeButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)bannerButtonPressed:(id)sender;
- (IBAction)categoriesButtonPressed:(id)sender;
- (IBAction)dateSelectButtonPressed:(id)sender;

@end
