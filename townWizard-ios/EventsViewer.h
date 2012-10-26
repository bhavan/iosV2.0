//
//  EvensViewer.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>

@class ActivityImageView;
@class DDPageControlCustom;

@interface EventsViewer : UIView {
    IBOutlet ActivityImageView *eventImage;
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *eventPlace;
    IBOutlet UILabel *eventTime;
    IBOutlet DDPageControlCustom *pageControl;
    IBOutlet UIView *detailsView;
    
    NSInteger currentEventIndex;
}

- (void) displayEvents:(NSArray *) events;

@end
