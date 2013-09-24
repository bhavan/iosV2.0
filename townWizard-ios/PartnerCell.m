//
//  PartnerCell.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/14/12.
//
//

#import "PartnerCell.h"

@implementation PartnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 18, 17)];
        [imgView setImage:[UIImage imageNamed:@"cellCircle"]];
        [self.contentView addSubview:imgView];
        
        UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
        separatorView.frame = CGRectMake(0, 48, 320, 2);
        [self addSubview:separatorView];
        [separatorView release];
        [imgView release];
    }
    return self;
}


@end
