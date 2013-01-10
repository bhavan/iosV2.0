//
//  EventsControllerView.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import <UIKit/UIKit.h>

@interface EventsView : UIView

@property (nonatomic,retain) IBOutlet UIButton *calendarButton;
@property (nonatomic,retain) IBOutlet UIButton *eventsTypeButton;
@property (nonatomic,retain) IBOutlet UIButton *addEventButton;
@property (nonatomic,retain) IBOutlet UIView *tableHeader;
@property (nonatomic,retain) IBOutlet UIView *tableFooter;

@end
