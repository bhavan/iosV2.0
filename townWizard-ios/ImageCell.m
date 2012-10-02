//
//  ImageCell.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "ImageCell.h"

@implementation ImageCell
@synthesize thumbImageView, nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 4.0, 66.0, 66.0)];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 200, 40)];
       // nameLabel.font = self.textLabel.font;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        thumbImageView.backgroundColor = [UIColor clearColor];
       // thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:thumbImageView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)dealloc
{
    [super dealloc];
    [nameLabel release];
    [thumbImageView release];
}

@end
