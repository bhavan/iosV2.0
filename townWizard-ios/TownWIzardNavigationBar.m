//
//  townWIzardNavigation.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TownWizardNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation TownWizardNavigationBar


//@synthesize menuButton;
//@synthesize titleLabel;
//@synthesize menuPage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor lightGrayColor];
//
//        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.menuButton setImage:[UIImage imageNamed:@"menuStarButton"] 
//                         forState:UIControlStateNormal];
//        [self.menuButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
//        self.menuButton.accessibilityLabel = @"Back";
//        self.menuButton.frame = CGRectMake(10, 6, 33, 30);
//        [self addSubview:self.menuButton];
//        
//        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(32, 3, 250, 20)] autorelease];
//
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.textAlignment = UITextAlignmentCenter;
//        self.titleLabel.layer.shadowRadius = 0.1;
//        self.titleLabel.layer.shadowOpacity = 0.4;
//        self.titleLabel.layer.masksToBounds = NO;
//        self.titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
//        self.titleLabel.shadowColor = [UIColor blackColor];
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.titleLabel];
//        
//        self.subMenuLabel = [[[UILabel alloc] initWithFrame:CGRectMake(32, 20, 250, 22)] autorelease];
//        
//        self.subMenuLabel.textColor = [UIColor whiteColor];
//        self.subMenuLabel.textAlignment = UITextAlignmentCenter;
//        self.subMenuLabel.layer.shadowRadius = 0.1;
//        self.subMenuLabel.layer.shadowOpacity = 0.4;
//        self.subMenuLabel.layer.masksToBounds = NO;
//        self.subMenuLabel.layer.shadowOffset = CGSizeMake(1, 1);
//        self.subMenuLabel.shadowColor = [UIColor blackColor];
//        self.subMenuLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.subMenuLabel];
    }
    return self;
}

- (void)dealloc
{
//    self.menuButton = nil;
//    self.titleLabel = nil;
//    self.menuPage = nil;
    [super dealloc];
}

- (void) layoutSubviews
{
        
}




@end
