//
//  ImageCell.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell
{
    UIImageView *thumbImageView;
    UILabel *nameLabel;
}

@property (nonatomic, retain) UIImageView *thumbImageView;
@property (nonatomic, retain) UILabel *nameLabel;

@end
