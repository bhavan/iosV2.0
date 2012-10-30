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
@class Section;
@class ActivityImageView;

@protocol PartnerMenuDelegate <NSObject>
@optional
- (void) sectionsUpdated:(NSArray *) sections;
- (void) menuSectionTapped:(Section *) section;
- (void) changePartnerButtonTapped;
@end

@interface PartnerMenuViewController : UIViewController
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *sectionsList;
    IBOutlet UITextField *searchField;
    IBOutlet ActivityImageView *partnerLogo;
}

@property (nonatomic, retain) Partner * partner;
@property (nonatomic, assign) id<PartnerMenuDelegate> delegate;

@end
