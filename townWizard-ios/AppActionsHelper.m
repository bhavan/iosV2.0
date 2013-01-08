//
//  AppActionsHelper.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/6/12.
//
//

#import "AppActionsHelper.h"
#import "RequestHelper.h"
#import "SubMenuViewController.h"
#import "MapViewController.h"
#import "Reachability.h"
#import "Event.h"
#import <EventKit/EventKit.h>
#import "NSDate+Formatting.h"
#import "NSString+HTMLStripping.h"

@implementation AppActionsHelper
static AppActionsHelper *actionsHelper = nil;

+ (id) sharedInstance
{
    @synchronized (self) {
        if (actionsHelper == nil) {
            actionsHelper = [[self alloc] init];
        }
    }
    return actionsHelper;
}
#pragma mark -
#pragma mark PartnerMethods

- (UIBarButtonItem *) menuButtonWithTarget:(id)target action:(SEL)action
{
    UIImage *menuButtonImage = [UIImage imageNamed:@"menu_button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:menuButtonImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (BOOL)townWizardServerReachable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"townwizard.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}


- (void)openUrl:(NSString *)urlString fromNavController:(UINavigationController *)navController
{
    if(urlString)
    {
        [[RequestHelper sharedInstance] setCurrentSection:nil];
        SubMenuViewController *subMenu = [SubMenuViewController new];
        subMenu.url = urlString;
        [navController pushViewController:subMenu animated:YES];
        [subMenu release];
    }
    
}

- (void)saveEvent:(Event *)event
{
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    if([eventDB respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    { // >= iOS 6
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
    myEvent.notes = [event.details stringByStrippingHTML];
    myEvent.location = event.location.address;
    myEvent.URL = [NSURL URLWithString:event.location.website];
    myEvent.title = event.title;
    NSDate *start = [NSDate dateFromString:event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:event.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    myEvent.startDate = start;
    myEvent.endDate = end;
    myEvent.allDay = NO;
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    NSError *err;
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
    NSString *alertTitle;
    if (err == noErr)
    {
        alertTitle = @"Event Created";
    }
    else
    {
        alertTitle = [NSString stringWithFormat:@"Error: %@",err.localizedDescription];
    }
    [UIAlertView showWithTitle:alertTitle message:nil confirmButtonTitle:@"Ok"];
    [eventDB release];

}

- (void)openMapWithTitle:(NSString *)title longitude:(double)longitude latitude:(double)latitude fromNavController:(UINavigationController *)navController
{
    MapViewController *viewController = [[MapViewController alloc] init];    
    viewController.latitude = latitude;
    viewController.longitude = longitude;
    viewController.topTitle = title;
    viewController.bShowDirection = YES;
    [navController pushViewController:viewController animated:YES];
    [viewController loadGoogleMap];    
    [viewController release];
    
}

- (void)makeCall:(NSString *)phoneNumber
{
	phoneNumberToCall = [phoneNumber copy];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:phoneNumber
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Call", nil];
	[alert setTag:1];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1)
	{
		if((buttonIndex == 1) && (phoneNumberToCall.length > 0))
		{
            [phoneNumberToCall autorelease];
            phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@"-" withString:@""];
			phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@"(" withString:@""];
			phoneNumberToCall = [phoneNumberToCall stringByReplacingOccurrencesOfString:@")" withString:@""];
			phoneNumberToCall = [NSString stringWithFormat:@"tel://%@",phoneNumberToCall];
            
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberToCall]];
		}
	}
    else
        [phoneNumberToCall release];
}




@end
