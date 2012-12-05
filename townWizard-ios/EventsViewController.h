//
//  EventsViewController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>

@class EventsViewer;


@interface EventsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
    
    IBOutlet EventsViewer *featuredEventsViewer;
    IBOutlet UITableView *eventsList;
    
    
    
    NSInteger currentCategory;
}

@property (retain, nonatomic) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) NSArray *categotiesList;
@property (retain, nonatomic) IBOutlet UIButton *eventsTypeButton;

- (void) loadTodayEvents;
- (void)loadEventsWithDatePeriod:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)filterEventsByCategory;
- (IBAction)categoriesButtonPressed:(id)sender;
- (IBAction)dateSelectButtonPressed:(id)sender;

@end
