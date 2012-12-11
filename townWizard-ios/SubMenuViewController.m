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
#import "FacebookPlacesViewController.h"
#import "Partner.h"
#import "Section.h"
#import "PartnerViewController.h"
#import "RequestHelper.h"

#define ROOT_URL @"app30a"
#define MAP_URL @"showmap"
#define DETAILS_URL @"showdetails"
#define FBCHECKIN_URL @"fbcheckin"
#define MAIL_URL @"mailto"
#define TEL_URL @"tel"
#define CALL_URL @"makecall"


@implementation SubMenuViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.navigationController.navigationBarHidden = NO;    

    NSString *urlString;
    Section *section = [[RequestHelper sharedInstance] currentSection];
    if(section)
    {
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
    UIImage *buttonImage = [[UIImage imageNamed:@"backButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 15)];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"  Back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    back = [[UIBarButtonItem alloc]initWithCustomView:btn];

    [btn release];
    
    partnerController = (id)self.navigationController.parentViewController;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

-(void)viewWillDisappear:(BOOL)animated
{ 
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    }
}

- (IBAction)goBackPressed:(id)sender
{
    [self.webView goBack];
}


#pragma mark -
#pragma mark webView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.scalesPageToFit = YES;
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(_webView.canGoBack)
    {
        self.navigationItem.leftBarButtonItem = back;
    }
    else if(!_url)
    {
        self.navigationItem.leftBarButtonItem =  [partnerController menuButton];
    }
    NSLog(@"Finish loading URL: %@",[webView.request URL]);

    if (self.view.window) //if webView is not on screen, we are not interested in setting this
        [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType
{    
    if(_webView.canGoBack)
    {
        self.navigationItem.leftBarButtonItem = back;
    }
    else if(!_url)
    {
        self.navigationItem.leftBarButtonItem =  [partnerController menuButton];
    }
    
    NSLog(@"Loading URL: %@",[request URL]);
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] >= 2)
    {
        NSString *rootUrlType = [[components objectAtIndex:0] lowercaseString];
        if([rootUrlType isEqualToString:ROOT_URL])
        {
            NSString *urlType = [[components objectAtIndex:1] lowercaseString];
            
            if( [urlType isEqualToString:CALL_URL])
            {
                [[AppActionsHelper sharedInstance] makeCall:[components objectAtIndex:2]];
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
                return YES;
                
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
            [[AppActionsHelper sharedInstance] makeCall:[components objectAtIndex:1]];
            return NO;
        }
        else if([rootUrlType isEqualToString:MAIL_URL])
        {
            [self mailUrlPressedWithComponents:components];
            return NO;
        }
    }
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    
    return YES;
}


- (void)showMapWithUrlComponents:(NSArray *)components
{
    NSString *title = [components objectAtIndex:4];
    title = [[title stringByReplacingOccurrencesOfString:@"+" withString:@" "]
             stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    [[AppActionsHelper sharedInstance] openMapWithTitle:title
                                         longitude:[[components objectAtIndex:2] doubleValue]
                                          latitude:[[components objectAtIndex:3] doubleValue] fromNavController:self.navigationController];    
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
