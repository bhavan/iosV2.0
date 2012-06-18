//
//  FacebookCheckinViewController.h
//  GenericApp
//
//  Created by John Doe on 6/16/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Place.h"
#import "Facebook.h"
#import "townWIzardNavigationBar.h"

@interface FacebookCheckinViewController : UIViewController <UITableViewDelegate, 
                                                            UITableViewDataSource,
                                                            FBRequestDelegate,
                                                            UITextFieldDelegate,UIScrollViewDelegate> 
{
    UITextField *messageView;
    UITextField *searchView;
    UITableView *friendsListView;
    Place *place;
    NSArray *friends;
    NSMutableSet *taggedFriends;
    NSString *filter;
    NSArray *filteredFriends;
    BOOL checkInProgress;
}

@property (nonatomic,retain) Place *place;
@property (nonatomic,retain) NSArray *friends;
@property (nonatomic,retain) NSArray *filteredFriends;

@property (nonatomic,retain) IBOutlet UITextField *messageView;
@property (nonatomic,retain) IBOutlet UITextField *searchView;
@property (nonatomic,retain) IBOutlet UITableView *friendsListView;

@property (nonatomic,retain) TownWizardNavigationBar * customNavigationBar;

- (id) initWithSelectedPlace:(Place *)place;

-(IBAction)dismissKeyboardByPressingRandomSpaceOnScreen:(id)sender;

- (IBAction) performCheckin;

@end
