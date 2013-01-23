//
//  EventDetailsViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import "EventDetailsViewController.h"
#import "FacebookPlacesViewController.h"
#import "Event.h"
#import "Location.h"
#import "AppDelegate.h"
#import "SubMenuViewController.h"
#import "NSDate+Formatting.h"
#import "RequestHelper.h"
#import "SHK.h"
#import "NSString+HTMLStripping.h"

@interface EventDetailsViewController ()
{
    BOOL isdescriptionLoaded;
}
@property (nonatomic, retain)NSString *bannerImageUrl;

@end

@implementation EventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                    UITextAttributeTextShadowOffset,
                                    [UIFont boldSystemFontOfSize:13.0f], UITextAttributeFont,
                                    nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:textAttributes
                                                         forState:UIControlStateNormal];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:textAttributes
                                                         forState:UIControlStateNormal];
    _topDetailView.detailWebView.delegate = self;
    _topDetailView.detailWebView.scrollView.scrollEnabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:self.view.frame
                                                         toView:self.view];
   
    if(_event)
    {
        [self loadWithEvent:_event];
    }
}

- (void)loadWithEvent:(Event *)event
{
    _event = event;
    [_topDetailView updateWithEvent:event];
}

- (void)updateBannerImage:(UIImage *)bannerImage urlString:(NSString *)urlString
{
    [_bannerImageView setImage:bannerImage];
    _bannerImageUrl = urlString;
}

- (IBAction)bannerButtonPressed:(id)sender
{
    [[AppActionsHelper sharedInstance] openUrl:_bannerImageUrl
                             fromNavController:self.navigationController];
}

- (IBAction)callButtonPressed:(id)sender
{
    [[AppActionsHelper sharedInstance] makeCall:_event.location.phone];
}

- (IBAction)webButtonPressed:(id)sender
{
    if(_event.location.website && _event.location.website.length > 0)
    {
        [[AppActionsHelper sharedInstance] openUrl:_event.location.website
                                 fromNavController:self.navigationController];
    }
    else
    {
        [UIAlertView showWithTitle:@"No website" message:nil confirmButtonTitle:@"Ok"];
    }
}

- (IBAction)mapButtonPressed:(id)sender
{
    if(_event.location.latitude && _event.location.longitude)
    {
        [[AppActionsHelper sharedInstance] openMapWithTitle:_event.location.address
                                                  longitude:[_event.location.longitude doubleValue]
                                                   latitude:[_event.location.latitude doubleValue]
                                          fromNavController:self.navigationController];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    [[AppActionsHelper sharedInstance] saveEvent:_event];
}

- (IBAction)checkInButtonPressed:(id)sender
{
    if (![[AppDelegate sharedDelegate].facebookHelper.appId isEqual:@""])
    {
        FacebookPlacesViewController *fpvc = [[FacebookPlacesViewController alloc]
                                              initWithLatitude:
                                              [_event.location.latitude doubleValue]
                                              andLongitude:
                                              [_event.location.longitude doubleValue]];
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSDate *startDate = [NSDate dateFromString:_event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate dateFromString:_event.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *eventDatePeriod = [NSString stringWithFormat:@"%@ to %@",
                                 [NSDate stringFromDate:startDate
                                             dateFormat:@"EEEE, LLLL d yyyy - h:mm a"],
                                 [NSDate stringFromDate:endDate
                                             dateFormat:@"h:mm a"]];
    SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@\n\n%@\n%@",
                                   _event.title,
                                   eventDatePeriod,
                                   [_event.details stringByStrippingHTML]]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	//[SHK setRootViewController:rootViewController];
	[actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIWebViewDelegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.frame = CGRectMake(0, 0, 320, webView.scrollView.contentSize.height);
    self.scrollView.contentSize = CGSizeMake(320, webView.frame.size.height+54);
    CGRect bottomRect = _contentBottomView.frame;
    bottomRect.origin.y = webView.scrollView.contentSize.height;
    _contentBottomView.frame = bottomRect;
    isdescriptionLoaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if (isdescriptionLoaded)
    {
        [[AppActionsHelper sharedInstance] openUrl:[request.URL absoluteString]
                                 fromNavController:self.navigationController];        
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [_event release];
    [_scrollView release];
    [_topDetailView release];
    [_bannerImageView release];
    [_contentBottomView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTopDetailView:nil];
    [self setBannerImageView:nil];
    [self setContentBottomView:nil];
    [super viewDidUnload];
}

@end
