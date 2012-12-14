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

@interface EventDetailsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,retain) Event *event;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet EventDetailTopView *topDetailView;
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;

- (IBAction)bannerButtonPressed:(id)sender;
- (void)loadWithEvent:(Event *)event;
- (IBAction)callButtonPressed:(id)sender;
- (IBAction)webButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)checkInButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (void)updateBannerImage:(UIImage *)bannerImage urlString:(NSString *)urlString;

@end
