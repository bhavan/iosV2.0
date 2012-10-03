//
//  townWIzardNavigation.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TownWizardNavigationBar : UIView {
    UIView *view;
}

@property (nonatomic, retain) UIViewController *menuPage;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *menuButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subMenuLabel;

@property (nonatomic,retain) UIImageView * backgroundImageView;
@property (nonatomic,retain) UIImageView * defaultBackground;

@end
