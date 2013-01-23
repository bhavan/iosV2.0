//
//  subMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"


@class Partner;
@class Section;
@class PartnerViewController;

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
{
    UIBarButtonItem *back;
    PartnerViewController *partnerController;
}

@property (nonatomic, retain) Partner *partner;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) Section * section;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign)  id <SubMenuViewControllerDelegate> delegate;

- (void)showMapWithUrlComponents:(NSArray *)components;
- (void)fbUrlPressedWithComponents:(NSArray *)components;
- (void)mailUrlPressedWithComponents:(NSArray *)components;
- (IBAction)goBackPressed:(id)sender;


@end
