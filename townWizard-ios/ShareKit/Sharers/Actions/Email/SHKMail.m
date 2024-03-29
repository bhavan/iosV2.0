//
//  SHKMail.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/17/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKConfiguration.h"
#import "SHKMail.h"


@implementation MFMailComposeViewController (SHK)

- (void)SHKviewDidDisappear:(BOOL)animated
{	
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window (but only if the view doesn't have another modal over it)
	if (self.presentedViewController == nil)
		[[SHK currentHelper] viewWasDismissed];
}

@end



@implementation SHKMail

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return SHKLocalizedString(@"Email");
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (BOOL)canShareFile
{
	return YES;
}

+ (BOOL)shareRequiresInternetConnection
{
	return NO;
}

+ (BOOL)requiresAuthentication
{
	return NO;
}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

+ (BOOL)canShare
{
	return [MFMailComposeViewController canSendMail];
}

- (BOOL)shouldAutoShare
{
	return YES;
}



#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{
	self.quiet = YES;
	
	if (![self validateItem])
		return NO;
	
	return [self sendMail]; // Put the actual sending action in another method to make subclassing SHKMail easier
}

- (BOOL)sendMail
{	
	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	if (!mailController) {
		// e.g. no mail account registered (will show alert)
		[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
		return YES;
	}
	
    [self retain]; //must retain, because mailController does not retain its delegates. Released in callback.
	mailController.mailComposeDelegate = self;
	mailController.navigationBar.tintColor = SHKCONFIG_WITH_ARGUMENT(barTintForView:,mailController);
	
	NSString *body = nil;
	BOOL isHTML = NO;
	NSString *separator = (isHTML ? @"<br/><br/>" : @"\n\n");
    
	if (body == nil)
	{
		if (item.text != nil)
			body = item.text;
		
		if (item.URL != nil)
		{	
			NSString *urlStr = [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			if (body != nil)
				body = [body stringByAppendingFormat:@"%@%@", separator, urlStr];
			
			else
				body = urlStr;
		}
		
		if (item.data)
		{
			NSString *attachedStr = SHKLocalizedString(@"Attached: %@", item.title ? item.title : item.filename);
			
			if (body != nil)
				body = [body stringByAppendingFormat:@"%@%@", separator, attachedStr];
			
			else
				body = attachedStr;
		}
		
		// fallback
		if (body == nil)
			body = @"";
		
		// sig
		//if (self.item.mailShareWithAppSignature)
		//{
			body = [body stringByAppendingString:separator];
			body = [body stringByAppendingString:SHKLocalizedString(@"Sent from %@", SHKCONFIG(appName))];
		//}
	}
	
	if (item.data)		
		[mailController addAttachmentData:item.data mimeType:item.mimeType fileName:item.filename];
	
/*	NSArray *toRecipients = self.item.mailToRecipients;
    if (toRecipients)
		[mailController setToRecipients:toRecipients];
    */
	if (item.image){
        
       
        [mailController addAttachmentData:UIImageJPEGRepresentation(item.image, 1.0f) mimeType:@"image/jpeg" fileName:@"Image.jpg"];
	}
	
	[mailController setSubject:item.title];
	[mailController setMessageBody:body isHTML:isHTML];
    NSShadow * shadow = [NSShadow new];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    shadow, NSShadowAttributeName,
                                    [UIFont boldSystemFontOfSize:13.0f], NSFontAttributeName,
                                    nil];

     [mailController.navigationItem.leftBarButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [mailController.navigationItem.rightBarButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
	[[SHK currentHelper] showViewController:mailController];
	
	return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
	
	switch (result) 
	{
		case MFMailComposeResultSent:
			[self sendDidFinish];
			break;
		case MFMailComposeResultSaved:
			[self sendDidFinish];
			break;
		case MFMailComposeResultCancelled:
			[self sendDidCancel];
			break;
		case MFMailComposeResultFailed:
			[self sendDidFailWithError:nil];
			break;
	}
    
    NSShadow * shadow = [NSShadow new];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], NSForegroundColorAttributeName,
                                    shadow, NSShadowAttributeName,
                                    [UIFont boldSystemFontOfSize:13.0f], NSFontAttributeName,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
	[self autorelease];
}


@end
