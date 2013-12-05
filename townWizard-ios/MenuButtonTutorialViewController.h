//
//  MenuButtonTutorialViewController.h
//  townWizard-ios
//
//  Created by Nickolay Sheika on 11/6/13.
//
//

@class MenuButtonTutorialViewController;

@protocol MenuButtonTutorialViewControllerDelegate

- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController dismissPressed:(UIButton *)sender;
- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController dontShowPressed:(UIButton *)sender;

@optional
- (void)menuButtonTutorialViewController:(MenuButtonTutorialViewController *)menuButtonTutorialViewController menuButtonHit:(UIButton *)menuButton;
@end

@interface MenuButtonTutorialViewController : UIViewController

@property (nonatomic, assign) id <MenuButtonTutorialViewControllerDelegate> delegate;

@end




