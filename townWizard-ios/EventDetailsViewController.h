//
//  EventDetailsViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import <GAITrackedViewController.h>
#import "EventDetailTopView.h"

@class Event;

@interface EventDetailsViewController : GAITrackedViewController <UIWebViewDelegate>

@property (retain, nonatomic) Event *event;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet EventDetailTopView *topDetailView;
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (retain, nonatomic) IBOutlet UIView *contentBottomView;

- (void) loadWithEvent:(Event *)event;
- (void) updateBannerImage:(UIImage *)bannerImage urlString:(NSString *)urlString;
- (IBAction) bannerButtonPressed:(id)sender;
- (IBAction) callButtonPressed:(id)sender;
- (IBAction) webButtonPressed:(id)sender;
- (IBAction) mapButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;
- (IBAction) checkInButtonPressed:(id)sender;
- (IBAction) shareButtonPressed:(id)sender;


@end
