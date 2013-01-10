//
//  SectionCell.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import <UIKit/UIKit.h>

@class ActivityImageView;
@class Section;

@interface SectionCell : UITableViewCell

@property (nonatomic, retain) IBOutlet ActivityImageView *sectionImage;
@property (nonatomic, retain) IBOutlet UIImageView *accessibilityIndicator;
- (void) updateWithSection:(Section *) section;

@end
