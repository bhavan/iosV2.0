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

- (void)openMapWithTitle:(NSString *)title longitude:(double)longitude latitude:(double)latitude fromNavController:(UINavigationController *)navController
{
    MapViewController *viewController = [[MapViewController alloc] init];
    
    viewController.m_dblLatitude = latitude;
    viewController.m_dblLongitude = longitude;
    viewController.m_sTitle = title;
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
