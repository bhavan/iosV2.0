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

@synthesize m_photo;
@synthesize partnerSiteURL;
@synthesize userName=_userName;
@synthesize userCaption = _userCaption;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	m_imageView.image = m_photo;
}

-(NSString *)userCaption
{
    if (!_userCaption) return @"";
    else return _userCaption;
}

-(NSString *)userName
{
    if (!_userName) return @"";
    else return _userName;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)cancelButtonPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)writeButtonPressed:(id)sender {
	m_captionView.frame = CGRectMake(77.0, 416.0, 165.0, 0.0);
	if([m_captionView superview] == nil) {
		[self.view addSubview:m_captionView];
	}
	
	[UIView beginAnimations:NULL context:nil];
	[UIView setAnimationDuration:0.35];
	m_captionView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
	[UIView commitAnimations];
	
	[m_txtName becomeFirstResponder];
	m_navigationBar.hidden = NO;
	[self.view bringSubviewToFront:m_navigationBar];
    
    m_txtName.text = self.userName;
    m_textView.text = self.userCaption;
}

- (IBAction)uploadButtonPressed:(id)sender {
	[m_activityIndicator startAnimating];
	[self.view bringSubviewToFront:m_activityIndicator];
	//[self dismissModalViewControllerAnimated:YES];
	[NSThread detachNewThreadSelector:@selector(addPhoto) toTarget:self withObject:nil];
}

- (void)hideCaptionView:(BOOL)animated {
	[UIView beginAnimations:NULL context:nil];
	[UIView setAnimationDuration:0.35];
	m_captionView.frame = CGRectMake(77.0, 460.0, 165.0, 0.0);
	[UIView commitAnimations];
	m_navigationBar.hidden = YES;
}

- (IBAction)textCancelButtonPressed:(id)sender {	
	[self hideCaptionView:YES];
	[m_textView resignFirstResponder];
	[m_txtName resignFirstResponder];
}

- (IBAction)textDoneButtonPressed:(id)sender {
	[self hideCaptionView:YES];
	[m_textView resignFirstResponder];
	[m_txtName resignFirstResponder];
    self.userName = m_txtName.text;
    self.userCaption = m_textView.text;
	[m_btnCaption setTitle:m_textView.text forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Upload photo

- (NSString*) urlStringForUpload {
	return [partnerSiteURL stringByAppendingString:uploadScriptURL];
}

- (void)addPhoto {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *stringBoundary = kBoundaryString;
	NSMutableData *body = [NSMutableData data];	
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"caption\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:self.userCaption] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:self.userName] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//NSString *m = m_textView.text;
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userphoto\"; filename=\"mainphoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:UIImageJPEGRepresentation(m_photo,1.0)]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userthumb\"; filename=\"thumb.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:UIImageJPEGRepresentation([self buildThumbImage:m_photo],0.5)]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSData *returnData = [self getOutputData:[self urlStringForUpload] BodyData:body];
	NSString *sReturnValue = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSString *msg = @"";
	NSString *title = @"";
	
	if([sReturnValue isEqualToString:@"1"])
	{
		msg = @"We will review and post\nyour photo ASAP.\nCheck back soon!";
		title = @"Thank you!";
        [TestFlight passCheckpoint:@"Photo uploaded!"];
	}
	else
	{
		msg = @"Error while uploading Photo";
		title = @"Server Error";
        [TestFlight passCheckpoint:@"Error while uploading photo"];
	}
	[sReturnValue release];
	
	[m_activityIndicator stopAnimating];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:msg 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
	[alert show];
	[alert release];	
	    
	[pool release];	
}

- (UIImage*)buildThumbImage:(UIImage*)image {
	CGSize thumbSize = CGSizeMake(60.0, 60.0);
	CGSize size = CGSizeMake(58.0, 58.0);
	CGSize sizeImage = image.size;
	
	CGFloat fWidth = size.width;
	CGFloat fHeight = size.height;
	
	if(sizeImage.width > sizeImage.height) {
		fHeight = (sizeImage.height * fWidth) / sizeImage.width;
	}
	else {
		fWidth = (sizeImage.width * fHeight) / sizeImage.height;
	}
	
	CGFloat fXOffset = 0.0;
	if(fWidth < size.width) {
		fXOffset = (size.width - fWidth) / 2.0;
	}
	
	CGFloat fYOffset = 0.0;
	if(fHeight < size.height) {
		fYOffset = (size.height - fHeight) / 2.0;
	}
	
	UIGraphicsBeginImageContext(thumbSize);
	[[UIImage imageNamed:@"Image-Border.png"] drawInRect:CGRectMake(0.0, 0.0, 
                                                                    thumbSize.width, thumbSize.height)];
	
	[image drawInRect:CGRectMake(fXOffset + 1.0, fYOffset + 1.0, fWidth, fHeight)];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

- (NSData *)getOutputData:(NSString *)sUrl BodyData:(NSData *)bodyData {
	
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
   //self.presentingViewController = imagePicker; self.presentingViewController.presentingViewController = SubMenuViewController
    
    [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark clean up

-(void)cleanUp
{
    [m_imageView release];
	[m_photo release];
    self.userName = nil;
    self.userCaption = nil;
}

-(void)viewDidUnload
{
    [self cleanUp];
    [super viewDidUnload];
}

- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}

@end
