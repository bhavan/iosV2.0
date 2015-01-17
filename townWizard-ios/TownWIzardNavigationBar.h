//
//  townWIzardNavigation.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailController.h"

@interface TownWizardNavigationBar : UINavigationBar<UINavigationBarDelegate>

@property (nonatomic, retain) UILabel *titleLabel;

- (CGRect)calculateTitleFrame;
- (void)updateTitleText:(NSString *) titleText;

@end
