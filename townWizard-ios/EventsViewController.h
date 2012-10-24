//
//  EventsViewController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>

@class EventsViewer;

@interface EventsViewController : UIViewController {
    
    IBOutlet EventsViewer *featuredEventsViewer;
    IBOutlet UITableView *eventsList;
}

@end
