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
@class Event;
@class EventsView;

@protocol EventViewerDelegate <NSObject>
- (void)eventTouched:(Event *) event;
@end


@interface EventsViewer : UIView
{
    IBOutlet ActivityImageView *eventImage;
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *eventPlace;
    IBOutlet UILabel *eventTime;
    IBOutlet DDPageControlCustom *pageControl;
    IBOutlet UIView *detailsView;
    NSInteger currentEventIndex;
}

@property (nonatomic, assign) BOOL isImagePresented;
@property (nonatomic, retain) EventsView *rootView;
@property (nonatomic, assign) id<EventViewerDelegate> delegate;

- (void) displayEvents:(NSArray *) events;

@end
