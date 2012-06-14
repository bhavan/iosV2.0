//
//  subMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TownWIzardNavigationBar;

@protocol SubMenuViewControllerDelegate
@optional
-(void)menuButtonPressed:(id)sender;
@end

@interface SubMenuViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
 

}


@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSDictionary *partnerInfoDictionary;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDictionary * sectionDictionary;
@property (nonatomic, retain) TownWIzardNavigationBar * customNavigationBar;
@property (retain, nonatomic) IBOutlet UIToolbar *bottomBar;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *webPageLoadingSpinner;
@property (nonatomic, assign)  id <SubMenuViewControllerDelegate> delegate;

@property (nonatomic,retain) NSMutableArray *places;

-(BOOL)townWizardServerReachable;
- (void)menuButtonPressed;

- (IBAction)goBackPressed:(id)sender;
- (IBAction)goForwardPressed:(id)sender;

-(void)showUploadTitle;

@end
