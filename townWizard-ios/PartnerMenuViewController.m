//
//  PartnerMenuViewController.m
//  townWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PartnerMenuViewController.h"
#import "subMenuViewController.h"
#import "townWIzardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "Reachability.h"
#import "AppDelegate.h"

@implementation PartnerMenuViewController
@synthesize scrollView=_scrollView;
@synthesize partnerSections=_partnerSections;
@synthesize partnerInfoDictionary=_partnerInfoDictionary;
@synthesize customNavigationBar=_customNavigationBar;
@synthesize delegate;
@synthesize currentSectionName=_currentSectionName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    partnerMenuButtons = [[NSMutableArray alloc] init];
    sectionImagesDictionary = [[NSMutableDictionary alloc] init];
}


-(void)setNameForNavigationBar
{
    NSString *partnerName = [self.partnerInfoDictionary objectForKey:@"name"];
    if (self.currentSectionName == nil) { 
        self.customNavigationBar.titleLabel.text = [NSString stringWithFormat:@"%@",
                                                    partnerName];
    }
    else {
        self.customNavigationBar.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                                    partnerName,self.currentSectionName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    subSections = nil;
    [self reloadMenu];
    [self.customNavigationBar.menuButton addTarget:self 
                                            action:@selector(menuButtonPressed) 
                                  forControlEvents:UIControlEventTouchUpInside];
    [self setNameForNavigationBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.customNavigationBar.menuButton removeTarget:self 
                                               action:@selector(menuButtonPressed) 
                                     forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    if (self.delegate)
        self.currentSectionName = nil;
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Buttons and images

- (void)displayImages {
    
    for(UIButton *btn in partnerMenuButtons) {
        NSString *key = [NSString stringWithFormat:@"%d",btn.tag];
        UIImage *image = (UIImage *)[sectionImagesDictionary objectForKey:key];
        
        UIImageView *imgview = [[UIImageView alloc] initWithImage:image];
        imgview.frame = CGRectMake(25, 10, 50, 50);
        
        [btn addSubview:imgview];
        [imgview release];
    }
}

- (void)loadImageForButton:(UIButton *)btn {

    NSArray *arr = self.partnerSections;
    if(subSections != nil && [subSections count]>0) {
        arr = subSections;
    }
    NSDictionary *section = [arr objectAtIndex:btn.tag];
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",
                                                SERVER_URL,[section objectForKey:@"image_url"]];
 
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl] 
                                               options:(NSUInteger)nil 
                                                 error:nil];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    
    UIImage* image = [[UIImage alloc] initWithData:imageData] ;
    NSString *key = [NSString stringWithFormat:@"%d",btn.tag];
    [sectionImagesDictionary setObject:image forKey:key];
    [image release];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayImages];
    });
    
}

#pragma  mark -
#pragma mark Spinner methods

#define BIG_SPINNER_SIZE 50

-(void)showSpinnerAtViewCenter:(UIView *)view
{
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] 
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGSize cellSize = view.frame.size;
    spinner.frame = CGRectMake(cellSize.width/2-BIG_SPINNER_SIZE/2, cellSize.height/2 - BIG_SPINNER_SIZE/2, 
                               BIG_SPINNER_SIZE, BIG_SPINNER_SIZE);
   
    [view addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
}

-(void)removeSpinnerFromView:(UIView *)view
{
    for (UIView * contentView in view.subviews)
    {
        if ([contentView isKindOfClass:[UIActivityIndicatorView class]])
        {
            [contentView removeFromSuperview];
        }
    }
}

#pragma mark -
#pragma mark Navigation

- (void)menuButtonPressed {
    if (self.delegate) 
        //If delegate is set, we are in section menu,so we should pop to partner selection screen
    {
        [self.delegate menuButtonPressed:self];
        [UIView animateWithDuration:0.35 animations:^{
            self.customNavigationBar.frame = CGRectMake(self.view.frame.size.width, 0, 
                                                        self.view.frame.size.width, 60);
        }];
    }
    else { 
        //IF delegate is not set, we are inside subsections menu, so we need to pop to sections menu
         [self.navigationController popViewControllerAnimated:YES];   
    }
}

#define BUTTON_SIZE 100
#define HORIZONTAL_SPACING 140
#define VERTICAL_SPACING 50
#define MINIMUM_SCROLL_VIEW_HEIGHT 400

- (void)reloadMenu {

    [partnerMenuButtons removeAllObjects];
    int i = 0;               
    NSArray * partnerSectionsArray = self.partnerSections;
    if(subSections != nil){
        [TestFlight passCheckpoint:@"Subsection loaded"];
        PartnerMenuViewController *subMenu = [[PartnerMenuViewController alloc] 
                                              initWithNibName:@"PartnerMenuViewController" 
                                                       bundle:nil];
        subMenu.customNavigationBar = self.customNavigationBar;
        self.customNavigationBar.menuPage = subMenu;
        //subMenu.delegate is not set, we dont want to pop to root view controller
        subMenu.partnerInfoDictionary = self.partnerInfoDictionary;
        subMenu.partnerSections = subSections;
        subMenu.currentSectionName = self.currentSectionName;
                                                    
        [self.navigationController pushViewController:subMenu animated:YES];
        [subMenu release];
        //Create child controller with subsections
    }
    else {
        if (self.view.window)//we are on screen
        {
               [self setNameForNavigationBar]; 
        }
         
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        int isEven;
        for(NSDictionary *section in partnerSectionsArray) {
            isEven = i%2;
            UIView * menuItem = [[UIView alloc] 
                                initWithFrame:CGRectMake(40 + (isEven * HORIZONTAL_SPACING), 
                                                         VERTICAL_SPACING*(i - isEven),
                                                         BUTTON_SIZE, 
                                                         BUTTON_SIZE)];  
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, BUTTON_SIZE, BUTTON_SIZE);
            UILabel * buttonTitle = [[UILabel alloc] 
                                     initWithFrame:CGRectMake(0, 60, BUTTON_SIZE, 35)];
            buttonTitle.text = [section objectForKey:@"display_name"];
            button.accessibilityLabel = [section objectForKey:@"display_name"];
            buttonTitle.textAlignment = UITextAlignmentCenter;
            [button addSubview:buttonTitle];   
            [buttonTitle release];
            [button addTarget:self 
                       action:@selector(goToSection:) 
             forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [menuItem addSubview:button];
            
            [self.scrollView addSubview:menuItem];    
            [menuItem release];
            
            [partnerMenuButtons addObject:button];
            [[UIApplication sharedApplication] showNetworkActivityIndicator];
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                                        initWithTarget:self
                                                              selector:@selector(loadImageForButton:) 
                                                                object:button];
            [queue addOperation:operation]; 
            [operation release];        
            i++;
        }
        [queue release]; 
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        int rows = (i/2+i%2);
        self.scrollView.contentSize = CGSizeMake(screenSize.width, rows*(2*VERTICAL_SPACING));
        if (self.scrollView.contentSize.height < MINIMUM_SCROLL_VIEW_HEIGHT)
            self.scrollView.contentSize = CGSizeMake(screenSize.width, MINIMUM_SCROLL_VIEW_HEIGHT);
    }
}

static NSString * const uploadScriptURL = @"/components/com_shines/iuploadphoto.php";

- (void)goToSection:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSArray * partnerSectionsArray = self.partnerSections;
    if(subSections != nil) {
        partnerSectionsArray = subSections;
    }
    NSDictionary * dict = [partnerSectionsArray objectAtIndex:btn.tag];
    NSArray *aSubSections = [dict objectForKey:@"sub_sections"];
    if([aSubSections count] == 0) {
        SubMenuViewController *subMenu=[[SubMenuViewController alloc] 
                                        initWithNibName:@"subMenuViewController" bundle:nil];
        subMenu.customNavigationBar = self.customNavigationBar;
        if(dict != nil) {       
            subMenu.partnerInfoDictionary = self.partnerInfoDictionary;
            subMenu.sectionDictionary = dict;
            NSString *sectionUrl = [NSString stringWithFormat:@"%@/%@",
                                    [self.partnerInfoDictionary objectForKey:@"website_url"],
                                    [dict objectForKey:@"url"]];
            subMenu.url = [sectionUrl stringByAppendingFormat:@"?&lat=%f&lon=%f",
                           [AppDelegate sharedDelegate].doubleLatitude,
                           [AppDelegate sharedDelegate].doubleLongitude];

        }
        [self.navigationController pushViewController:subMenu animated:YES];

        if ([[dict objectForKey:@"section_name"] isEqual:@"Photos"])
        {
            dispatch_queue_t checkQueue =  dispatch_queue_create("check reachability", NULL);
            dispatch_async(checkQueue, ^{
                NSString * uploadUrl = [NSString stringWithFormat:@"%@%@",
                                        [self.partnerInfoDictionary objectForKey:@"website_url"],
                                        uploadScriptURL];
                if ([Reachability reachabilityWithURL:[NSURL URLWithString:uploadUrl]])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                            [subMenu showUploadTitle];
                        });
                }
            });
            dispatch_release(checkQueue);
        }
        [subMenu release];    
    }
    else {
        subSections = aSubSections;
        self.currentSectionName = [NSString stringWithString:[dict objectForKey:@"section_name"]];
        [self reloadMenu];        
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark CleanUp

-(void)cleanUp
{
    self.scrollView = nil;
    self.partnerSections = nil;
    [partnerMenuButtons release];
    [sectionImagesDictionary release];
    _currentSectionName = nil;
    [[UIApplication sharedApplication] setActivityindicatorToZero];
}

- (void)viewDidUnload {
    [self cleanUp];
    [super viewDidUnload]; 
}

- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}
@end
