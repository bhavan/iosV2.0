//
//  UIBarButtonItem+TWButtons.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/11/13.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TWButtons)

+ (UIBarButtonItem *) menuButtonWithTarget:(id)target
                                    action:(SEL)action;

+ (UIBarButtonItem *) backButtonWithTarget:(id)target
                                    action:(SEL)action;

@end
