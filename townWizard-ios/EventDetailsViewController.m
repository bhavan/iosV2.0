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
    [_topDetailView updateWithEvent:event];   
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
    myEvent.location = _event.location.address;
    myEvent.URL = [NSURL URLWithString:_event.location.website];
    myEvent.title = _event.title;
    NSDate *start = [NSDate dateFromString:_event.startTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:_event.endTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
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
        FacebookPlacesViewController * fpvc = [[FacebookPlacesViewController alloc] init];
        //initWithLatitude:48.00885 andLongitude:37.8023];        
       
        [self.navigationController pushViewController:fpvc animated:YES];
        [fpvc release];
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
 
    SHKItem *item = [SHKItem text:@"teeest"];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	//[SHK setRootViewController:rootViewController];
	[actionSheet showInView:self.view];
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
