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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 18, 17)];
        [imgView setImage:[UIImage imageNamed:@"cellCircle"]];
        [self.contentView addSubview:imgView];        
        [imgView release];
    }
    return self;
}


@end
