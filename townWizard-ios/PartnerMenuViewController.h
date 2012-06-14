//
//  PartnerMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TownWIzardNavigationBar;

@protocol PartnerMenuViewControllerDelegate
@optional
-(void)menuButtonPressed:(id)sender;
@end

@interface PartnerMenuViewController : UIViewController <UIAlertViewDelegate>
{
    NSMutableArray * partnerMenuButtons;
    NSArray * subSections;
    NSMutableDictionary * sectionImagesDictionary;
   
    id <PartnerMenuViewControllerDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSArray * partnerSections;
@property (nonatomic, retain) NSDictionary * partnerInfoDictionary;
@property (nonatomic, retain) TownWIzardNavigationBar * customNavigationBar;
@property (nonatomic, weak) id <PartnerMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString * currentSectionName;

- (void) goToSection:(id)sender;
- (void) reloadMenu;
- (void) loadImageForButton:(UIButton *)btn;

-(void) showSpinnerAtViewCenter:(UIView *)view;
-(void) removeSpinnerFromView:(UIView *)view;

@end
