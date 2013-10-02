//
//  UIAlertView+Extensions.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import "UIAlertView+Extensions.h"

@implementation UIAlertView (Extensions)

+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id) delegate
              cancelButtonTitle:(NSString *)cancelTitle
             confirmButtonTitle:(NSString *)confirmTitle
{
    UIAlertView *alert = [[self alloc] initWithTitle:title
                                             message:message
                                            delegate:delegate
                                   cancelButtonTitle:cancelTitle
                                   otherButtonTitles:confirmTitle, nil];
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id)delegate
             confirmButtonTitle:(NSString *)confirmTitle
{
    return [self showWithTitle:title
                       message:message
                      delegate:delegate
             cancelButtonTitle:nil
            confirmButtonTitle:confirmTitle];
}

+ (UIAlertView *) showWithTitle:(NSString *)title
                        message:(NSString *)message
             confirmButtonTitle:(NSString *)confirmTitle
{
    return [self showWithTitle:title
                       message:message
                      delegate:nil
            confirmButtonTitle:confirmTitle];
}

+ (UIAlertView *)showConnectionProblemMessage {
    return [self showWithTitle:@"No data connectivity" message:nil confirmButtonTitle:@"OK"];
}

@end
