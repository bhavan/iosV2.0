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
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];

        thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 4.0, 66.0, 66.0)];
        [thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
        [thumbImageView setClipsToBounds:YES];
        [thumbImageView setBackgroundColor:[UIColor clearColor]];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 60)];
        nameLabel.numberOfLines = 2;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:thumbImageView];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)dealloc
{    
    [nameLabel release];
    [thumbImageView release];
    [super dealloc];
}

@end
