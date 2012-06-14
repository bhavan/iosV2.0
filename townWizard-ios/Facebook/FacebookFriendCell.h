//
//  FacebookFriendCellView.h
//  GenericApp
//
//  Created by John Doe on 6/17/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FacebookFriend;

@interface FacebookFriendCell : UITableViewCell {
    FacebookFriend *currentFriend;
    
    IBOutlet UIImageView* photo;
    IBOutlet UILabel* name;
}

- (void) setFriend:(FacebookFriend *)friend;
- (void) loadImageFor:(FacebookFriend *)friend;

@end
