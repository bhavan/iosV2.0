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

@protocol PartnerMenuDelegate <NSObject>
@optional
-(void)menuButtonPressed:(id)sender;

- (void) sectionsUpdated:(NSArray *) sections;
- (void) menuSectionTapped:(Section *) section;
- (void) changePartnerButtonTapped;
@end

@interface PartnerMenuViewController : UIViewController <UIAlertViewDelegate, RKObjectLoaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *subSections;
    NSMutableDictionary * sectionImagesDictionary;
   
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSArray * partnerSections;

}

@property (nonatomic, assign) id<PartnerMenuDelegate> delegate;

@property (nonatomic, retain) UINavigationController *childNavigationController;
@property (nonatomic, retain) NSArray * partnerSections;
@property (nonatomic, retain) Partner * partner;
@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (nonatomic, retain) NSString * currentSectionName;
@property (retain, nonatomic) IBOutlet UITableView *partnersTableView;

- (IBAction)changePartnerButtonPressed:(id)sender;

@end
