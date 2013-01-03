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
    NSTimer *currentTimer;
}

@property (nonatomic, assign) BOOL isImagePresented;
@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, retain) id<EventViewerDelegate> delegate;

- (void) displayEvents:(NSArray *) events;

@end
