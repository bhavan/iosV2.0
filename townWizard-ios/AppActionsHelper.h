//
//  AppActionsHelper.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/6/12.
//
//

#import <Foundation/Foundation.h>

@interface AppActionsHelper : NSObject
{
        NSString *phoneNumberToCall;
}
+ (id) sharedInstance;
- (BOOL)townWizardServerReachable;
- (UIBarButtonItem *) menuButtonWithTarget:(id)target action:(SEL)action;
- (void)makeCall:(NSString *)phoneNumber;
- (void)openUrl:(NSString *)urlString fromNavController:(UINavigationController *)navController;
- (void)openMapWithTitle:(NSString *)title longitude:(double)longitude latitude:(double)latitude fromNavController:(UINavigationController *)navController;

@end
