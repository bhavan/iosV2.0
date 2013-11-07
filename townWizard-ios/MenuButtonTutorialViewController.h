//
//  MenuButtonTutorialViewController.h
//  townWizard-ios
//
//  Created by Nickolay Sheika on 11/6/13.
//
//

#import <UIKit/UIKit.h>


@class MenuButtonTutorialViewController;

@protocol MenuButtonTutorialViewControllerDelegate

- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController dismissPressed:(UIButton *)sender;
- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController dontShowPressed:(UIButton *)sender;

@end




@interface MenuButtonTutorialViewController : UIViewController

@property (nonatomic, assign) id <MenuButtonTutorialViewControllerDelegate> delegate;

@end




