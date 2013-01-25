//
//  FacebookFriendCellView.m
//  GenericApp
//
//  Created by John Doe on 6/17/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookFriendCell.h"
#import "FacebookFriend.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_OFFSET 50

@implementation FacebookFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -

- (void) setFriend:(FacebookFriend *)friend {
    currentFriend = friend;
    
    [[photo layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[photo layer] setBorderWidth:2.0f];
    
    [name setText:friend.name];
      
    if (friend.avatar) {
        [photo setImage:friend.avatar];
    }
    else {
        [photo setImage:nil];
        [self performSelectorInBackground:@selector(loadImageFor:) withObject:friend];
    }
}

- (void) loadImageFor:(FacebookFriend *)friend {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [friend loadImage];
    if (friend == currentFriend && friend.avatar) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [photo setImage:friend.avatar];
        });
        // we do not need to reload data in the tableView, it is unsafe, since we do not own TableView
        /*[tableView performSelectorOnMainThread:@selector(reloadData) 
                                    withObject:nil 
                                 waitUntilDone:NO];*/
    }
    [pool drain];
}

#pragma mark - Memory management

- (void)dealloc {
    [name release];
    [photo release];
    [super dealloc];
}

@end
