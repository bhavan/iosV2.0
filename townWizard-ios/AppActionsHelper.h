//
//  AppActionsHelper.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/6/12.
//
//

#import <Foundation/Foundation.h>

@class Event;

@interface AppActionsHelper : NSObject
{
        NSString *phoneNumberToCall;
}
+ (id) sharedInstance;
- (BOOL)townWizardServerReachable;
- (void)makeCall:(NSString *)phoneNumber;
- (void)openUrl:(NSString *)urlString fromNavController:(UINavigationController *)navController;

- (void)openMapWithTitle:(NSString *)title longitude:(double)longitude latitude:(double)latitude fromNavController:(UINavigationController *)navController;
- (void)saveEvent:(Event *)event;
- (UIView *)putTWBackgroundWithFrame:(CGRect)frame toView:(UIView *)view;

@end
