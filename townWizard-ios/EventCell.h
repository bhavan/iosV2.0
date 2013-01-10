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

@property (nonatomic, retain) IBOutlet UILabel *eventTitle;
@property (nonatomic, retain) IBOutlet UILabel *eventLocation;
@property (nonatomic, retain) IBOutlet UILabel *eventTime;
@property (nonatomic, retain) IBOutlet UILabel *eventCategory;
@property (nonatomic, retain, readonly) Event *event;

- (void) updateWithEvent:(Event *) event;


@end
