//
//  EventsViewController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>
#import "EventsViewer.h"

@class EventsViewer;


@interface EventsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,
    EventViewerDelegate> {
    
    IBOutlet EventsViewer *featuredEventsViewer;
    IBOutlet UITableView *eventsList;
    

    
    NSInteger currentCategory;
}

@property (retain, nonatomic) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) NSArray *categotiesList;
@property (retain, nonatomic) IBOutlet UIButton *eventsTypeButton;

- (IBAction)categoriesButtonPressed:(id)sender;
- (IBAction)dateSelectButtonPressed:(id)sender;
- (NSString *)stringFromPeriod:(NSDate *)start end:(NSDate *)end;
@end
