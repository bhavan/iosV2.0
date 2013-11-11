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

@property (retain, nonatomic) IBOutlet UIImageView *menuButtonImageView;
@property (retain, nonatomic) IBOutlet UILabel *menuButtonLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *dismissButton;
@property (retain, nonatomic) IBOutlet UIButton *dontShowButton;

@end

@implementation MenuButtonTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.descriptionLabel setTextColor:[UIColor whiteColor]];
    [self.menuButtonLabel setTextColor:[UIColor whiteColor]];
    
    if ( ! SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.dismissButton.backgroundColor = [UIColor whiteColor];
        self.dontShowButton.backgroundColor = [UIColor whiteColor];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [_menuButtonImageView release];
    [_menuButtonLabel release];
    [_descriptionLabel release];
    [_dismissButton release];
    [_dontShowButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMenuButtonImageView:nil];
    [self setMenuButtonLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDismissButton:nil];
    [self setDontShowButton:nil];
    [super viewDidUnload];
}

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

@end
