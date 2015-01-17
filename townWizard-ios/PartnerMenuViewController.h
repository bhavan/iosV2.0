//
//  PartnerMenuViewController.h
//  townWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GAITrackedViewController.h>

@class Partner;
@class Section;
@class ActivityImageView;

@protocol PartnerMenuDelegate <NSObject>
@optional
- (void) startUpdating;
- (void) stopUpdating;
- (void) sectionsUpdated:(NSArray *) sections;
- (void) menuSectionTapped:(Section *) section;
- (void) changePartnerButtonTapped;
@end

@interface PartnerMenuViewController : GAITrackedViewController
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *sectionsList;
    IBOutlet UITextField *searchField;
    IBOutlet ActivityImageView *partnerLogo;    
    NSMutableDictionary *menu;
}

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) Partner * partner;
@property (nonatomic, assign) id<PartnerMenuDelegate> delegate;

- (void) updateWithPartner:(Partner *)aPartner;
- (IBAction)aboutButtonPressed:(id)sender;
- (BOOL)isInfoSection:(Section *)section;

@end
