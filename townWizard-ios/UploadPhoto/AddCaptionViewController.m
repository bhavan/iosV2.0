//
//  AddCaptionViewController.m
//  30A
//
//  Created by MAC1 on 27/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddCaptionViewController.h"


static NSString* const kBoundaryString = @"0xKhTmLbOuNdArY";
static NSString * const uploadScriptURL = @"/components/com_shines/iuploadphoto.php";

@implementation AddCaptionViewController

@synthesize photo;
@synthesize partnerSiteURL;
@synthesize userName;
@synthesize userCaption;
@synthesize activityIndicator;
@synthesize mainImageView;
@synthesize captionButton;
@synthesize captionView;
@synthesize m_navigationBar;
@synthesize textView;
@synthesize nameTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	mainImageView.image = photo;
}

-(NSString *)userCaption
{
    if (!userCaption) return @"";
    else return userCaption;
}

-(NSString *)userName
{
    if (!userName) return @"";
    else return userName;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)cancelButtonPressed:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)writeButtonPressed:(id)sender
{
	captionView.frame = CGRectMake(77.0, 416.0, 165.0, 0.0);
	if([captionView superview] == nil)
    {
		[self.view addSubview:captionView];
	}

    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         captionView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
                     }
                     completion:^(BOOL finished) {
                         captionView.hidden = NO;
                     }];
	
	[nameTextField becomeFirstResponder];
	m_navigationBar.hidden = NO;
	[self.view bringSubviewToFront:m_navigationBar];
    
    nameTextField.text = self.userName;
    textView.text = self.userCaption;
}

- (IBAction)uploadButtonPressed:(id)sender
{
	[activityIndicator startAnimating];
	[self.view bringSubviewToFront:activityIndicator];
	//[self dismissModalViewControllerAnimated:YES];
	[NSThread detachNewThreadSelector:@selector(addPhoto) toTarget:self withObject:nil];
}

- (void)hideCaptionView:(BOOL)animated
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         captionView.frame = CGRectMake(77.0, 460.0, 165.0, 0.0);
                     }
                     completion:^(BOOL finished) {
                         captionView.hidden = YES;
                     }];
	m_navigationBar.hidden = YES;
}

- (IBAction)textCancelButtonPressed:(id)sender
{
	[self hideCaptionView:YES];
	[textView resignFirstResponder];
	[nameTextField resignFirstResponder];
}

- (IBAction)textDoneButtonPressed:(id)sender
{
	[self hideCaptionView:YES];
	[textView resignFirstResponder];
	[nameTextField resignFirstResponder];
    self.userName = nameTextField.text;
    self.userCaption = textView.text;
	[captionButton setTitle:textView.text forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Upload photo

- (NSString*) urlStringForUpload
{
	return [partnerSiteURL stringByAppendingString:uploadScriptURL];
}

- (void)addPhoto
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	NSData *body = [[RequestHelper sharedInstance] uploadRequestDataForImage:self.photo
                                                                     caption:self.userCaption
                                                                    userName:self.userName];
	NSData *returnData = [self getOutputData:[self urlStringForUpload] BodyData:body];
	NSString *sReturnValue = [[NSString alloc] initWithData:returnData
                                                   encoding:NSUTF8StringEncoding];
	NSString *msg = @"";
	NSString *title = @"";
	
	if([sReturnValue isEqualToString:@"1"])
	{
		msg = @"We will review and post\nyour photo ASAP.\nCheck back soon!";
		title = @"Thank you!";
	}
	else
	{
		msg = @"Error while uploading Photo";
		title = @"Server Error";
	}
	[sReturnValue release];
	
	[activityIndicator stopAnimating];
	[UIAlertView showWithTitle:title
                       message:msg
                      delegate:self
            confirmButtonTitle:@"OK"];
	
	    
	[pool release];	
}


- (NSData *)getOutputData:(NSString *)sUrl BodyData:(NSData *)bodyData
{	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sUrl]];
	[request setHTTPMethod: @"POST"];
	
	NSString *stringBoundary = kBoundaryString;
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	[request setHTTPBody:bodyData];		
	
	NSURLResponse* response;
	NSError* error;
	
	// now lets make the connection to the web
	NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&response 
                                                     error:&error];
	return data;
}


#pragma mark -
#pragma mark <UIAlertViewDelegate> Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark clean up

-(void)cleanUp
{
    [mainImageView release];
    [captionButton release];
    [captionView release];
    [textView release];
	[photo release];
    [nameTextField release];
    [activityIndicator release];
    self.userName = nil;
    self.userCaption = nil;
}

-(void)viewDidUnload
{
    [self cleanUp];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self cleanUp];
    [super dealloc];
}

@end
