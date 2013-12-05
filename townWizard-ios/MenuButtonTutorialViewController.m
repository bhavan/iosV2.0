//
//  MenuButtonTutorialViewController.m
//  townWizard-ios
//
//  Created by Nickolay Sheika on 11/6/13.
//
//

#import "MenuButtonTutorialViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface MenuButtonTutorialViewController ()


@property (retain, nonatomic) IBOutlet UIButton *menuButton;
@property (retain, nonatomic) IBOutlet UILabel *menuButtonLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *dismissButton;
@property (retain, nonatomic) IBOutlet UIButton *dontShowButton;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation MenuButtonTutorialViewController


// ****************************************************************
#pragma mark - View Controller Lifecycle
// ****************************************************************

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.descriptionLabel setTextColor:[UIColor whiteColor]];
    [self.menuButtonLabel setTextColor:[UIColor whiteColor]];

    self.menuButtonLabel.text = NSLocalizedString(@"MENU BUTTON", nil);
    self.descriptionLabel.text = NSLocalizedString(@"TUTOR_DESCR_TEXT", nil);
    [self.dismissButton setTitle:NSLocalizedString(@"DISMISS_BTN_LABEL", nil) forState:UIControlStateNormal];
    [self.dontShowButton setTitle:NSLocalizedString(@"DONTSHOW_BTN_LABEL", nil)
                         forState:UIControlStateNormal];
    [self.dontShowButton sizeToFit];

    CGRect frame = self.dontShowButton.frame;
    frame.size.width +=10;
    if (frame.size.width < self.dismissButton.frame.size.width)
        frame.size.width = self.dismissButton.frame.size.width;
    frame.size.height = 40;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)*.5f;
    self.dontShowButton.frame = frame;

    if ( ! SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.dismissButton.backgroundColor = [UIColor whiteColor];
        self.dontShowButton.backgroundColor = [UIColor whiteColor];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self bounceAnimations];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    _delegate = nil;
    [_menuButtonLabel release];
    [_descriptionLabel release];
    [_dismissButton release];
    [_dontShowButton release];
    [_arrowImageView release];
    [_menuButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMenuButtonLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDismissButton:nil];
    [self setDontShowButton:nil];
    [self setArrowImageView:nil];
    [self setMenuButton:nil];
    [super viewDidUnload];
}


// ****************************************************************
#pragma mark - Actions
// ****************************************************************

- (IBAction)dismissButtonPressed:(UIButton *)sender
{
    [self.delegate menuButtonTutorialViewController:self
                                     dismissPressed:sender];
}

- (IBAction)dontShowButtonPressed:(UIButton *)sender
{
    [self.delegate menuButtonTutorialViewController:self
                                    dontShowPressed:sender];
}

- (IBAction)menuButtonHit:(id)sender
{
    if (self.delegate)
    {
        if ([(NSObject *)self.delegate respondsToSelector:@selector(menuButtonTutorialViewController:menuButtonHit:)])
        {
            [self.delegate menuButtonTutorialViewController:self menuButtonHit:sender];
        }
    }
}

// ****************************************************************
#pragma mark - Animations
// ****************************************************************

- (void)bounceAnimations
{
    CGAffineTransform scaleUpTransform = CGAffineTransformMakeScale(1.1f, 1.1f);
    CGAffineTransform scaleDownTransform = CGAffineTransformMakeScale(1.0f, 1.0f);  // use this <1.0 for more pulsing

    [UIView animateWithDuration:0.125f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.arrowImageView.transform = scaleUpTransform;
                         self.menuButtonLabel.transform = scaleUpTransform;
    }
                     completion: nil];
}

@end
