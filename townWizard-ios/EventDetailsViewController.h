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
- (IBAction)callButtonPressed:(id)sender;
- (IBAction)webButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)checkInButtonPressed:(id)sender;

@end
