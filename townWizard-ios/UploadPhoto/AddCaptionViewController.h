//
//  AddCaptionViewController.h
//  30A
//
//  Created by MAC1 on 27/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCaptionViewController : UIViewController {

	IBOutlet UIImageView *m_imageView;
	IBOutlet UIButton *m_btnCaption;
	IBOutlet UINavigationBar *m_navigationBar;
	
	IBOutlet UIView *m_captionView;
	IBOutlet UITextView *m_textView;
	IBOutlet UITextField *m_txtName;
	
	UIImage *m_photo;
    IBOutlet UIActivityIndicatorView *m_activityIndicator;
}

@property (nonatomic, retain) UIImage *m_photo;
@property (nonatomic,retain) NSString * userName;
@property (nonatomic,retain) NSString * userCaption;

@property (nonatomic,retain) NSString * partnerSiteURL;

- (UIImage*)buildThumbImage:(UIImage*)image;
- (NSData *)getOutputData:(NSString *)sUrl BodyData:(NSData *)bodyData;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)writeButtonPressed:(id)sender;
- (IBAction)uploadButtonPressed:(id)sender;
- (IBAction)textCancelButtonPressed:(id)sender;
- (IBAction)textDoneButtonPressed:(id)sender;

@end
