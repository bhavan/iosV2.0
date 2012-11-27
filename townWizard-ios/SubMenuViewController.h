//
//  subMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"

@class TownWizardNavigationBar;
@class Partner;
@class Section;

@protocol SubMenuViewControllerDelegate
@optional
-(void)menuButtonPressed:(id)sender;
@end

@interface SubMenuViewController : UIViewController
<UIWebViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
MFMailComposeViewControllerDelegate>



@property (nonatomic, retain) Partner *partner;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) Section * section;
@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *webPageLoadingSpinner;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign)  id <SubMenuViewControllerDelegate> delegate;

- (void)showUploadTitle;
- (void)showMapWithUrlComponents:(NSArray *)components;
- (IBAction)goBackPressed:(id)sender;
- (IBAction)goForwardPressed:(id)sender;
- (void)fbUrlPressedWithComponents:(NSArray *)components;
- (void)mailUrlPressedWithComponents:(NSArray *)components;


@end
