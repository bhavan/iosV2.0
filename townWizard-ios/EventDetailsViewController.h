//
//  EventDetailsViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import "EventDetailTopView.h"

@class Event;

@interface EventDetailsViewController : UIViewController 

@property (nonatomic,retain) Event *event;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet EventDetailTopView *topDetailView;

- (void)loadWithEvent:(Event *)event;

@end
