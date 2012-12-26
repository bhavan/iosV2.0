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
#import "MapViewController.h"
#import <EventKit/EventKit.h>
#import "NSDate+Formatting.h"
#import "RequestHelper.h"
#import "TWBackgroundView.h"
#import "SHK.h"

@interface EventDetailsViewController ()
{
    BOOL isdescriptionLoaded;
}

@property (nonatomic, retain)NSString *bannerImageUrl;

-(NSString *) stringByStrippingHTML:(NSString *)string;

@end

@implementation EventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                    [UIFont boldSystemFontOfSize:13.0f], UITextAttributeFont,
                                    nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    _topDetailView.detailWebView.delegate = self;
    _topDetailView.detailWebView.scrollView.scrollEnabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TWBackgroundView *backgroundView = [[TWBackgroundView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:backgroundView atIndex:0];
    [backgroundView release];
    //[self.scrollView addSubview:_topDetailView];
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
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No website"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
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
    
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    if([eventDB respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // >= iOS 6
        
        [eventDB requestAccessToEntityType:EKEntityTypeEvent
                                   completion:^(BOOL granted, NSError *error) {
                                       
                                       // may return on background thread
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (granted) {
                                               // continue
                                           } else {
                                               // display error
                                           }
                                       });
                                   }];
    }
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    myEvent.notes = [self stringByStrippingHTML:_event.details];
    myEvent.location = _event.location.address;
    myEvent.URL = [NSURL URLWithString:_event.location.website];
    myEvent.title = _event.title;
    NSDate *start = [NSDate dateFromString:_event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:_event.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    myEvent.startDate = start;
    myEvent.endDate = end;
    myEvent.allDay = NO;
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    NSError *err;
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
    if (err == noErr)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Event Created"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"Error: %@",err.localizedDescription]
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [eventDB release];
}

- (IBAction)checkInButtonPressed:(id)sender
{
    if (![[AppDelegate sharedDelegate].facebookHelper.appId isEqual:@""])
    {               
        FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc] initWithLatitude:[_event.location.latitude doubleValue] andLongitude:[_event.location.longitude doubleValue]];
      
       
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSDate *startDate = [NSDate dateFromString:_event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate dateFromString:_event.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *eventDatePeriod = [NSString stringWithFormat:@"%@ to %@",
                                 [NSDate stringFromDate:startDate dateFormat:@"EEEE, LLLL d yyyy - h:mm a"],
                                 [NSDate stringFromDate:endDate dateFormat:@"h:mm a"]];
    SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@\n\n%@\n%@", _event.title, eventDatePeriod,  [self stringByStrippingHTML:_event.details]]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	//[SHK setRootViewController:rootViewController];
	[actionSheet showInView:self.view];
}

-(NSString *) stringByStrippingHTML:(NSString *)string
{
    NSRange r;
    NSString *result = [[string copy] autorelease];
    while ((r = [result rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        result = [result stringByReplacingCharactersInRange:r withString:@""];
    return result;
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
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
