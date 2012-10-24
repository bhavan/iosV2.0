//
//  EvensViewer.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>

@interface EventsViewer : UIView {
    IBOutlet UIImageView *eventImage;
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *eventPlace;
    IBOutlet UILabel *eventTime;
    IBOutlet UIPageControl *pageControl;
}

- (void) displayEvents:(NSArray *) events;

@end
