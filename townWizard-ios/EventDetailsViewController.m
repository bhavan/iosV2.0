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

@interface EventDetailsViewController ()

@end



@implementation EventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TWBackgroundView *backgroundView = [[TWBackgroundView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:backgroundView atIndex:0];
    [backgroundView release];
    [self.scrollView addSubview:_topDetailView];
    if(_event)
    {
        [self loadWithEvent:_event];
    }
}

- (void)loadWithEvent:(Event *)event
{
    _event = event;
    _topDetailView.eventTitleLabel.text = event.title;
    _topDetailView.eventAdress.text = event.location.address;
    [_topDetailView.callButton setTitle:event.location.phone forState:UIControlStateNormal];
}

- (IBAction)callButtonPressed:(id)sender {
    [[AppDelegate sharedDelegate] makeCall:_event.location.phone];
}

- (IBAction)webButtonPressed:(id)sender {
    if(_event.location.website && _event.location.website.length >0)
    {
        [[RequestHelper sharedInstance] setCurrentSection:nil];
        SubMenuViewController *subMenu = [SubMenuViewController new];
        subMenu.url = _event.location.website;
        [self.navigationController pushViewController:subMenu animated:YES];
        [subMenu release];
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

- (IBAction)mapButtonPressed:(id)sender {
    MapViewController *viewController = [[MapViewController alloc] init];
    if(_event.location.latitude && _event.location.longitude)
    {
        viewController.m_dblLatitude = [_event.location.latitude doubleValue];
        viewController.m_dblLongitude = [_event.location.longitude doubleValue];
    }
    viewController.m_sTitle = _event.location.address;
    viewController.bShowDirection = YES;
    //  viewController.customNavigationBar = self.navigationController.navigationBar;
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
}

- (IBAction)saveButtonPressed:(id)sender
{
    
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    myEvent.location = _event.location.address;
    myEvent.URL = [NSURL URLWithString:_event.location.website];
    myEvent.title     = _event.title;
    NSDate *start = [NSDate dateFromString:_event.startTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:_event.endTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    myEvent.startDate = start;
    myEvent.endDate   = end;
    myEvent.allDay = NO;
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    NSError *err;
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
    if (err == noErr) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Event Created"
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
        FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc] init];
        //initWithLatitude:48.00885 andLongitude:37.8023];        
       
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_scrollView release];
    [_topDetailView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTopDetailView:nil];
    [super viewDidUnload];
}
@end
