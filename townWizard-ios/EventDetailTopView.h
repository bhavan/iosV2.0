//
//  EventDetailTopView.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventDetailTopView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventAdress;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
@property (retain, nonatomic) IBOutlet UIButton *webButton;
@property (retain, nonatomic) IBOutlet UIButton *mapButton;

- (UIImage *) buttonBackgroundImage;
- (void)updateWithEvent:(Event *)event;



@end
