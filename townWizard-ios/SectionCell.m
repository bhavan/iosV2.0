//
//  SectionCell.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import "SectionCell.h"
#import "Section.h"
#import "ActivityImageView.h"
#import "SectionImageManager.h"

#define kTitleOffset 45

@interface SectionCell ()
@property (nonatomic, retain) Section *section;
@end

@implementation SectionCell

@synthesize sectionImage;
@synthesize accessibilityIndicator;

#pragma mark -
#pragma mark life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[self textLabel] setHighlightedTextColor:[UIColor blackColor]];
        [[self textLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    }
    return self;
}

- (void) dealloc
{
    [sectionImage release];
    [accessibilityIndicator release];
    [self setSection:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = [[self textLabel] frame];
    titleFrame.origin.x = kTitleOffset;
    titleFrame.size.width = CGRectGetMinX([accessibilityIndicator frame]) - kTitleOffset;
    [[self textLabel] setFrame:titleFrame];
}

- (void) updateWithSection:(Section *) section
{
    [self setSection:section];
    [section setName:[[section name] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]];
    [section setDisplayName:[[section displayName]
                             stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]];
    [[self textLabel] setText:[section displayName]];
    
    UIImage *image = [[SectionImageManager sharedInstance] imageForSection:section];
    if (image == nil)
    {
        image = [UIImage imageNamed:@"iconStar"];
    }
    // bhavan: following "else if" will never execut as image==nil is always false.
    // keepign this logic to implement menu image download from url.
    //else if (image == nil && [section imageUrl])
    //{
    //    NSString *urlString = [[[RequestHelper sharedInstance] currentPartner] webSiteUrl];
    //    urlString = [[urlString stringByAppendingString:[section imageUrl]]
    //                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [sectionImage setImageWithURL:[NSURL URLWithString:urlString]];
    //}
     
     [sectionImage setImage:image];
}

@end
