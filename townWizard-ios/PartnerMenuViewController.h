//
//  PartnerMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TownWizardNavigationBar;
@class Partner;

@protocol PartnerMenuViewControllerDelegate
@optional
-(void)menuButtonPressed:(id)sender;
@end

@interface PartnerMenuViewController : UIViewController <UIAlertViewDelegate, RKObjectLoaderDelegate>
{
    NSMutableArray * partnerMenuButtons;
    NSArray *subSections;
    NSMutableDictionary * sectionImagesDictionary;
   
    id <PartnerMenuViewControllerDelegate> delegate;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSArray * partnerSections;
@property (nonatomic, retain) Partner * partner;
@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, weak) id <PartnerMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString * currentSectionName;

- (void) goToSection:(id)sender;
- (void) reloadMenu;
- (void) loadImageForButton:(UIButton *)btn;

@end
