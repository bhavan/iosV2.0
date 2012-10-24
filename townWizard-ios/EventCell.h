//
//  EventCell.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell {
    IBOutlet
}

- (void) updateWithEvent:(Event *) event;

@end
