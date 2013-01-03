//
//  EventCell.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell
{
    IBOutlet UILabel *eventTitle;
    IBOutlet UILabel *eventLocation;
    IBOutlet UILabel *eventTime;
    IBOutlet UILabel *eventCategory;
}

- (void) updateWithEvent:(Event *) event;
@property (nonatomic, retain, readonly) Event *event;

@end
