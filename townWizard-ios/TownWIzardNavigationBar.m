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

@synthesize backButton;
@synthesize menuButton;
@synthesize titleLabel;
@synthesize menuPage;
@synthesize defaultBackground=_defaultBackground;

@synthesize backgroundImageView=_backgroundImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*self.backgroundColor = [UIColor colorWithRed:(79.0/255.0) 
                                               green:(79.0/255.0) 
                                                blue:(81.0/255.0)
                                               alpha:1];*/
        UIImageView * defaultBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UIImage * defaultBackgroundImage = [UIImage imageNamed:@"topBar.png"];
        defaultBackgroundImageView.image = defaultBackgroundImage;
        self.defaultBackground = defaultBackgroundImageView;
        [self addSubview:self.defaultBackground];
        [defaultBackgroundImageView release];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 60)];
        self.backgroundImageView = imageView;
        [imageView release];
        [self addSubview:self.backgroundImageView];
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.menuButton setImage:[UIImage imageNamed:@"back_arrow_retina.png"] 
                         forState:UIControlStateNormal];
        self.menuButton.accessibilityLabel = @"Back";
        self.menuButton.frame = CGRectMake(10, 9, 40, 40);
        [self addSubview:self.menuButton];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(32, 2, 250, 56)] autorelease];

        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.layer.shadowRadius = 0.1;
        self.titleLabel.layer.shadowOpacity = 0.4;
        self.titleLabel.layer.masksToBounds = NO;
        self.titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
    
        self.titleLabel.shadowColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];    
        
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 110, 300, 400)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        [view setHidden:YES];        
    }
    return self;
}

- (void)dealloc {
    self.backButton = nil;
    self.menuButton = nil;
    self.titleLabel = nil;
    self.menuPage = nil;
    self.defaultBackground = nil;
    self.backgroundImageView = nil;
    [view release];
    [super dealloc];
}


@end
