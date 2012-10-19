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


@implementation SubMenuViewController

@synthesize webView=_webView;
@synthesize partner=_partner;
@synthesize section=_section;
@synthesize url=_url;
@synthesize customNavigationBar=_customNavigationBar;
@synthesize bottomBar = _bottomBar;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize webPageLoadingSpinner = _webPageLoadingSpinner;
@synthesize places=_places;
@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(NSMutableArray *)places
{
    if (!_places)
        _places = [[NSMutableArray alloc] init];
    return _places;
}

-(BOOL)townWizardServerReachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"townwizard.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];  
    self.webView.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
  
    self.customNavigationBar.titleLabel.text = self.partner.name;
    self.customNavigationBar.subMenuLabel.text = self.section.displayName;
    
    if (!self.partner)
    {
        self.customNavigationBar.titleLabel.text=@"";
    }
    
    if([self townWizardServerReachable]) {
        NSURL *aUrl = [NSURL URLWithString:self.url];
        [self.webView loadRequest:[NSURLRequest requestWithURL:aUrl]];
    } else { // NO connection
        [TestFlight passCheckpoint:@"No connection available while loading webView"];
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:NSLocalizedString(@"No connection available!", @"AlertView")
                                  message:NSLocalizedString(@"Please connect to cellular network or Wi-Fi", @"AlertView")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"AlertView")
                                  otherButtonTitles:NSLocalizedString(@"Open settings", @"AlertView"), nil];
        [alertView show];
        [alertView release];
    }
    
}


- (IBAction)goBackPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForwardPressed:(id)sender {
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
    [self.customNavigationBar.menuButton removeTarget:self 
                                               action:@selector(menuButtonPressed) 
                                     forControlEvents:UIControlEventTouchUpInside];
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
	
	if(actionSheet.tag == 1) {
		if(buttonIndex == 1) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
				ImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
		else if(buttonIndex == 0) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				ImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
	}
	else if(actionSheet.tag == 2) {
		if(buttonIndex == 0) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
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
                  editingInfo:(NSDictionary *)editingInfo {
	
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

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.webPageLoadingSpinner startAnimating];
    webView.scalesPageToFit = YES;
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
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
        if( [(NSString *)[components objectAtIndex:0] caseInsensitiveCompare:@"app30a"] == NSOrderedSame ) 
        {
            if( [(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"makecall"] == NSOrderedSame )  
            {   // phone number link
                [[AppDelegate sharedDelegate] makeCall:[components objectAtIndex:2]];
                return NO;
            }
            else if( [(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"showdetails"] == NSOrderedSame )  
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
                return NO;
            }
            else if( [(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"showmap"] == NSOrderedSame )  
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
                return NO;
            }
            else if( [(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"fbcheckin"] == NSOrderedSame ) 
            {
                if ([[AppDelegate sharedDelegate].facebookHelper.appId isEqual:@""])
                {
                    return NO;
                }
            
                FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc] init];
                                                       //initWithLatitude:48.00885 andLongitude:37.8023];
                
                fpvc.customNavigationBar = self.customNavigationBar;
                [self.navigationController pushViewController:fpvc animated:YES];
                [fpvc release];
                
                return NO;
                
            }
            return NO;
        }
        else if( [(NSString *)[components objectAtIndex:0] caseInsensitiveCompare:@"tel"] == NSOrderedSame ) 
            {
                [[AppDelegate sharedDelegate] makeCall:[components objectAtIndex:1]];
                return NO;
            }
        else if( [(NSString *)[components objectAtIndex:0] caseInsensitiveCompare:@"mailto"] == NSOrderedSame ) 
        {
            
            // open native email application:
            // [[UIApplication sharedApplication] openURL:[request URL]];
            
            
            // open inside the app:
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
                [[UIApplication sharedApplication] openURL:[request URL]];
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support the composer sheet"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert release];*/
            }
        } 
    }
    //OMG govnokod ended
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        return YES;
}

#pragma mark - MFComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark CleanUp

-(void)cleanUp {
    self.partner = nil;
    self.section = nil;
    self.webView = nil;
    [_url release];
    [[UIApplication sharedApplication] setActivityindicatorToZero];
    self.places = nil;
    
    [self setBottomBar:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setWebPageLoadingSpinner:nil];
}

- (void)viewDidUnload {
    [self cleanUp];
    [super viewDidUnload];    
}

- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}
@end
