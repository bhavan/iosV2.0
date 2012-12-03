//
//  SubMenuViewController.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "Reachability.h"
#import "UIApplication+NetworkActivity.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "AddCaptionViewController.h"
#import "Facebook.h"
#import "FacebookFriend.h"
#import "Place.h"
#import "FacebookPlacesViewController.h"
#import "Partner.h"
#import "Section.h"
#import "PhotoUploadView.h"

#import "RequestHelper.h"

#define ROOT_URL @"app30a"
#define MAP_URL @"showmap"
#define DETAILS_URL @"showdetails"
#define FBCHECKIN_URL @"fbcheckin"
#define MAIL_URL @"mailto"
#define TEL_URL @"tel"
#define CALL_URL @"makecall"


@implementation SubMenuViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    
    NSString *urlString;
    Section *section = [[RequestHelper sharedInstance] currentSection];
    if ([section url] != nil)
    {
        urlString = [NSString stringWithFormat:@"%@/%@",
                     [[[RequestHelper sharedInstance] currentPartner] webSiteUrl],
                     [section url]];
    }
    else
    {
        urlString = @"http://www.townwizardoncontainerapp.com";
    }
    urlString = [urlString stringByAppendingFormat:@"?&lat=%f&lon=%f",
                   [AppDelegate sharedDelegate].doubleLatitude,
                   [AppDelegate sharedDelegate].doubleLongitude];

    [[self webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


- (IBAction)goBackPressed:(id)sender
{
    [self.webView goBack];
}

- (IBAction)goForwardPressed:(id)sender
{
    [self.webView goForward];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [self.customNavigationBar.menuButton removeTarget:self
    //                                               action:@selector(menuButtonPressed)
    //                                     forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Photo Upload

-(void)showUploadTitle
{
    [UIView animateWithDuration:0.35 animations:^{
        [self.webView setFrame:CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y+31,
                                          self.webView.frame.size.width, self.webView.frame.size.height-31)];
    }];
    
    PhotoUploadView *uploadView = [[PhotoUploadView alloc] initWithParentController:self];
    [self.view addSubview:uploadView];
    [uploadView release];
}

- (void)cameraButtonPressed:(id)sender {
	AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *menu = [[UIActionSheet alloc]
							   initWithTitle: @""
							   delegate:self
							   cancelButtonTitle:@"Cancel"
							   destructiveButtonTitle:nil
							   otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
		[menu setTag:1];
		[menu showInView:appdelegate.window];
		[menu release];
	}
	else {
		UIActionSheet *menu = [[UIActionSheet alloc]
							   initWithTitle: @""
							   delegate:self
							   cancelButtonTitle:@"Cancel"
							   destructiveButtonTitle:nil
							   otherButtonTitles:@"Choose from Library", nil];
		[menu setTag:2];
		[menu showInView:appdelegate.window];
		[menu release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 2) //Cancel button
		return;
	
	UIImagePickerController* ImageController = [[UIImagePickerController alloc] init];
	//ImageController.allowsImageEditing = YES;
	ImageController.delegate = self;
	
	if(actionSheet.tag == 1)
    {
		if(buttonIndex == 1)
        {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
				ImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
		else if(buttonIndex == 0)
        {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
				ImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
	}
	else if(actionSheet.tag == 2)
    {
		if(buttonIndex == 0)
        {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
				ImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
	}
	
	[ImageController release];
}

#pragma mark -
#pragma mark <UIImagePickerControllerDelegate> Methods

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
	
	//[(PhotoGalleryViewController *)parent dismissModalViewControllerAnimated:YES];
	
	AddCaptionViewController *viewController = [[AddCaptionViewController alloc]
                                                initWithNibName:@"AddCaptionViewController"
                                                bundle:nil];
    
    viewController.partnerSiteURL = self.partner.webSiteUrl;
	viewController.m_photo = image;
    [picker presentModalViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark -
#pragma mark webView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.webPageLoadingSpinner startAnimating];
    webView.scalesPageToFit = YES;
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    [self.webPageLoadingSpinner stopAnimating];
    if (self.view.window) //if webView is not on screen, we are not interested in setting this
        [[UIApplication sharedApplication] setActivityindicatorToZero];
}

-(BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL: %@",[request URL]);
    // OMG govnokod started
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] >= 2) {
        NSString *rootUrlType = [[components objectAtIndex:0] lowercaseString];
        if([rootUrlType isEqualToString:ROOT_URL])
        {
            NSString *urlType = [[components objectAtIndex:1] lowercaseString];
            
            if( [urlType isEqualToString:CALL_URL])
            {
                [[AppDelegate sharedDelegate] makeCall:[components objectAtIndex:2]];
            }
            else if( [urlType isEqualToString:DETAILS_URL])
            {
                // more info link
                /* PlaceInfo* info = [[[PlaceInfo alloc] init] autorelease];
                 info.iRestaurantId = [[components objectAtIndex:2] integerValue];
                 info.dblDistance = [[components objectAtIndex:3] doubleValue];
                 
                 PlaceDetailsViewController *viewController = [[PlaceDetailsViewController alloc] initWithInfo:info];
                 viewController.placeInfo = info;
                 [[GenericAppAppDelegate sharedDelegate] subNavigateTo:viewController];
                 [viewController release];*/
                [TestFlight passCheckpoint:@"Show details link clicked"];
            }
            else if([urlType isEqualToString:MAP_URL])
            {
                [self showMapWithUrlComponents:components];
            }
            else if([urlType isEqualToString:FBCHECKIN_URL])
            {
                [self fbUrlPressedWithComponents:components];
                
            }
            return NO;
        }
        else if([rootUrlType isEqualToString:TEL_URL])
        {
            [[AppDelegate sharedDelegate] makeCall:[components objectAtIndex:1]];
            return NO;
        }
        else if([rootUrlType isEqualToString:MAIL_URL])
        {
            [self mailUrlPressedWithComponents:components];
        }
    }
    //OMG govnokod ended
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    return YES;
}

- (void)showMapWithUrlComponents:(NSArray *)components
{
    MapViewController *viewController = [[MapViewController alloc] init];
    if ([components count] >= 5) {
        NSString *title = [components objectAtIndex:4];
        viewController.m_sTitle =
        [[title stringByReplacingOccurrencesOfString:@"+" withString:@" "]
         stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    viewController.m_dblLatitude = [[components objectAtIndex:2] doubleValue];
    viewController.m_dblLongitude = [[components objectAtIndex:3] doubleValue];
    viewController.bShowDirection = YES;
    viewController.customNavigationBar = self.customNavigationBar;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}


- (void)mailUrlPressedWithComponents:(NSArray *)components
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString * emailAddress = [[components objectAtIndex:1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *toRecipients = [NSArray arrayWithObjects:emailAddress, nil];
        [mailer setToRecipients:toRecipients];
        
        //                NSString *emailBody = @"Sending letter using TownWizard application?";
        //                [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];        
        [mailer release];
    }
    else
    {
        // [[UIApplication sharedApplication] openURL:[request URL]];
    }   
    
}

- (void)fbUrlPressedWithComponents:(NSArray *)components
{
    if (![[AppDelegate sharedDelegate].facebookHelper.appId isEqual:@""])
    {
        FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc] init];
        //initWithLatitude:48.00885 andLongitude:37.8023];
        
        fpvc.customNavigationBar = self.customNavigationBar;
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
    
}
#pragma mark - MFComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark CleanUp

-(void)cleanUp
{
    self.partner = nil;
    self.section = nil;
    self.webView = nil;
    [_url release];
    [[UIApplication sharedApplication] setActivityindicatorToZero];
    [self setBottomBar:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setWebPageLoadingSpinner:nil];
}

- (void)viewDidUnload
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
