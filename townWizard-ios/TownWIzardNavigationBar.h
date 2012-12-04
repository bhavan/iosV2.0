//
//  townWIzardNavigation.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailController.h"

@interface TownWizardNavigationBar : UINavigationBar {
}

- (void) updateTitleText:(NSString *) titleText;
@property (nonatomic, retain) UILabel *titleLabel;
@end
