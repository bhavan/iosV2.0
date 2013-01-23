//
//  AddCaptionViewController.h
//  30A
//
//  Created by MAC1 on 27/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCaptionViewController : UIViewController
{	
	UIImage *photo;    
}

@property (nonatomic, retain) IBOutlet UIImageView *mainImageView;
@property (nonatomic, retain) IBOutlet UIButton *captionButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *m_navigationBar;
@property (nonatomic, retain) IBOutlet UIView *captionView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userCaption;
@property (nonatomic, retain) NSString *partnerSiteURL;

- (NSData *)getOutputData:(NSString *)sUrl BodyData:(NSData *)bodyData;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)writeButtonPressed:(id)sender;
- (IBAction)uploadButtonPressed:(id)sender;
- (IBAction)textCancelButtonPressed:(id)sender;
- (IBAction)textDoneButtonPressed:(id)sender;

@end
