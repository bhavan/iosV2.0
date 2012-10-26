//
//  ActivityImageView.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/25/12.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface ActivityImageView : UIImageView {
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

@end
