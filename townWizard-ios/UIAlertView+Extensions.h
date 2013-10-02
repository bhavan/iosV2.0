//
//  UIAlertView+Extensions.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Extensions)

+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id) delegate
              cancelButtonTitle:(NSString *)cancelTitle
             confirmButtonTitle:(NSString *)confirmTitle;
+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id)delegate
             confirmButtonTitle:(NSString *)confirmTitle;
+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
             confirmButtonTitle:(NSString *)confirmTitle;

+ (UIAlertView *)showConnectionProblemMessage;

@end
