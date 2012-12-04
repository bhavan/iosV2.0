//
//  EventDetailTopView.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import "EventDetailTopView.h"

@implementation EventDetailTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    [_eventTitleLabel release];
    [_eventAdress release];
    [super dealloc];
}
@end
