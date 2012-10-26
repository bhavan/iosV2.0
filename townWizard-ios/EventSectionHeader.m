//
//  EventSectionHeader.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/26/12.
//
//

#import "EventSectionHeader.h"

static const CGFloat kEventSectionHeaderTitleOffsetLeft = 10;
static const CGFloat kEventSectionHeaderTitleOffsetTop = 5;

@interface EventSectionHeader ()
@property (nonatomic, retain, readwrite) UILabel *title;
@end

@implementation EventSectionHeader

#pragma mark -
#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImage *patternImage = [UIImage imageNamed:@"event_header_bg"];
        UIColor *backgroundColor = [UIColor colorWithPatternImage:patternImage];
        [self setBackgroundColor:backgroundColor];
        
        self.title = [[UILabel new] autorelease];
        [[self title] setBackgroundColor:[UIColor clearColor]];
        [[self title] setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:[self title]];
    }
    return self;
}

- (void) dealloc
{
    [self setTitle:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = CGRectMake(kEventSectionHeaderTitleOffsetLeft,
                                   kEventSectionHeaderTitleOffsetTop,
                                   [self bounds].size.width - 2 * kEventSectionHeaderTitleOffsetLeft,
                                   [[[self title] font] pointSize]);
    [[self title] setFrame:titleFrame];
}

@end
