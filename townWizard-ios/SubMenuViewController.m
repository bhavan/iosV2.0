//
//  SubMenuViewController.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubMenuViewController.h"
#import "UIApplication+NetworkActivity.h"
#import "AppDelegate.h"
#import "FacebookPlacesViewController.h"
#import "Partner.h"
#import "Section.h"
#import "PartnerViewController.h"
#import "RequestHelper.h"
#import "UIButton+Extensions.h"
#import "UIAlertView+Extensions.h"
#import "UIBarButtonItem+TWButtons.h"

#define ROOT_URL @"app30a"
#define MAP_URL @"showmap"
#define DETAILS_URL @"showdetails"
#define FBCHECKIN_URL @"fbcheckin"
#define MAIL_URL @"mailto"
#define TEL_URL @"tel"
#define CALL_URL @"makecall"

@interface SubMenuViewController ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SubMenuViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    back = [[UIBarButtonItem backButtonWithTarget:self action:@selector(goBackPressed:)] retain];
    partnerController = (id)self.navigationController.parentViewController;
    
    [self loadWebViewPage];
}

- (void)loadWebViewPage {
    NSString *urlString = self.url;
    Section *section = [[RequestHelper sharedInstance] currentSection];

    if(section)
    {
        urlString = [self urlFromSection:section];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed
                                            timeoutInterval:15];
    [[self webView] loadRequest:urlRequest];
}

- (NSString *)urlFromSection:(Section*)section
{
    NSString *urlString;
    if ([section url] != nil)
    {
        if([self isSectionUrlAbsolute:section.url])
        {
            urlString = section.url;
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@/%@",
                         [[[RequestHelper sharedInstance] currentPartner] webSiteUrl],
                         [section url]];
        }
    }
    else
    {
        urlString = @"http://www.townwizardoncontainerapp.com";
    }
    
    // bhavan: append latitude/longitude with either "?" or "&" based on if other query string parameters exist
    NSRange searchRange = [urlString rangeOfString:@"?"];
    
    if (searchRange.length != 0)
    {
        // "?" exists, i.e. urlString has other query string paramerts 
        urlString = [urlString stringByAppendingFormat:@"&lat=%f&lon=%f",
                     [AppDelegate sharedDelegate].doubleLatitude,
                     [AppDelegate sharedDelegate].doubleLongitude];
    }
    else
    {
        // "?" is not there; no other query string parameter in urlString
        urlString = [urlString stringByAppendingFormat:@"?lat=%f&lon=%f",
                     [AppDelegate sharedDelegate].doubleLatitude,
                     [AppDelegate sharedDelegate].doubleLongitude];
    }
    return urlString;
}

- (BOOL)isSectionUrlAbsolute:(NSString *)urlString
{
    NSRange range = [urlString rangeOfString:@"http://"];
    if(range.length > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupLeftButton
{
    if(_webView.canGoBack)
    {
        self.navigationItem.leftBarButtonItem = back;
    }
    else if(!_url && partnerController)
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                                 menuButtonWithTarget:partnerController
                                                 action:@selector(toggleMasterView)];
    }

}

#pragma mark -
#pragma mark webView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.scalesPageToFit = YES;

    [[self activityIndicator] stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setupLeftButton];
    [[self activityIndicator] stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [self setupLeftButton];
    [[self activityIndicator] startAnimating];
    
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];    
    if ([components count] >= 2)
    {
        return [self parseUrlComponents:components];
    }
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[self activityIndicator] stopAnimating];
    [UIAlertView showConnectionProblemMessage];
}

- (BOOL)parseUrlComponents:(NSArray *)components
{
    NSString *rootUrlType = [[components objectAtIndex:0] lowercaseString];
    NSString *urlType = rootUrlType;
    if([rootUrlType isEqualToString:ROOT_URL])
    {
        urlType = [[components objectAtIndex:1] lowercaseString];
    }
    return [self actionForUrlType:urlType withComponents:components];
    
}

- (BOOL)actionForUrlType:(NSString *)urlType withComponents:(NSArray *)components
{
    if( [urlType isEqualToString:CALL_URL])
    {
        [[AppActionsHelper sharedInstance] makeCall:[components objectAtIndex:2]];
        return NO;
    }
    else if( [urlType isEqualToString:DETAILS_URL])
    {
        return YES;
    }
    else if([urlType isEqualToString:MAP_URL])
    {
        [self showMapWithUrlComponents:components];
        return NO;
    }
    else if([urlType isEqualToString:FBCHECKIN_URL])
    {
        [self fbUrlPressedWithComponents:components];
        return NO;
    }
    else if([urlType isEqualToString:TEL_URL])
    {
        [[AppActionsHelper sharedInstance] makeCall:[components objectAtIndex:1]];
        return NO;
    }
    else if([urlType isEqualToString:MAIL_URL])
    {
        [self mailUrlPressedWithComponents:components];
        return NO;
    }
    return YES;
}


- (void)showMapWithUrlComponents:(NSArray *)components
{
    NSString *title = @"";
    if(components.count > 4)
    {
        title = [components objectAtIndex:4];
        title = [[title stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                 stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    [[AppActionsHelper sharedInstance] openMapWithTitle:title
                                              longitude:[[components objectAtIndex:3] doubleValue]
                                               latitude:[[components objectAtIndex:2] doubleValue] fromNavController:self.navigationController];
}

- (void)mailUrlPressedWithComponents:(NSArray *)components
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString * emailAddress = [[components objectAtIndex:1]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *toRecipients = [NSArray arrayWithObjects:emailAddress, nil];
        [mailer setToRecipients:toRecipients];
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
        FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc]
                                               initWithLatitude:
                                               [[components objectAtIndex:2] doubleValue]
                                               andLongitude:
                                               [[components objectAtIndex:3] doubleValue]];
      
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
    
}
#pragma mark - MFComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CleanUp

-(void)cleanUp
{
    [back release];
    [_url release];
    self.partner = nil;
    self.section = nil;
    self.webView = nil;   
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload
{
    [self cleanUp];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self cleanUp];
    [_activityIndicator release];
    [super dealloc];
}

@end
