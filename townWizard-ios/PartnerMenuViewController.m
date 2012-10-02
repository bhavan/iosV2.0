//
//  PartnerMenuViewController.m
//  TownWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PartnerMenuViewController.h"
#import "SubMenuViewController.h"
#import "TownWizardNavigationBar.h"
#import "UIApplication+NetworkActivity.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "Section.h"
#import "UIImageView+WebCache.h"
#import "PhotoCategoriesViewController.h"
#import "RequestHelper.h"


#define URL_HEADER @"http://"

@implementation PartnerMenuViewController
@synthesize scrollView=_scrollView;
@synthesize partnerSections=_partnerSections;
@synthesize partner;
@synthesize customNavigationBar=_customNavigationBar;
@synthesize delegate;
@synthesize currentSectionName=_currentSectionName;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        partnerMenuButtons = [[NSMutableArray alloc] init];
        sectionImagesDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setHidesBackButton:YES];
#ifdef PARTNER_ID
    CGRect barFrame = CGRectMake(0, 0, [[self view] frame].size.width, 60);
    TownWizardNavigationBar *bar = [[TownWizardNavigationBar alloc] initWithFrame:barFrame];
    [self setCustomNavigationBar:bar];
    [self.navigationController.navigationBar addSubview:bar];
    [bar release];
    
    [self restorePartnerDetails];
    [self loadPartnerLogo];
#endif
}


-(void)setNameForNavigationBar
{   
    if (self.currentSectionName == nil) { 
        self.customNavigationBar.titleLabel.text = [NSString stringWithFormat:@"%@",
                                                    self.partner.name];
    }
    else {
        self.customNavigationBar.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                                    self.partner.name,self.currentSectionName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

#ifdef CONTAINER_APP

    subSections = nil;
    [self reloadMenu];
    [self.customNavigationBar.menuButton addTarget:self 
                                            action:@selector(menuButtonPressed) 
                                  forControlEvents:UIControlEventTouchUpInside];
    [self setNameForNavigationBar];

    
#else
    //caching disabled
    self.partnerInfoDictionary = nil;
    self.partnerSections = nil;
    // -----
    
    if ([self partnerInfoDictionary] == nil) {
        [self loadPartnerDetails];
    }
    else {
        if ([self partnerSections] == nil) {
            [self loadPartnerSections];
        }
        else {
            [self reloadMenu];
        }
    }    
    [[[self customNavigationBar] menuButton] setHidden:YES];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.customNavigationBar.menuButton removeTarget:self 
                                               action:@selector(menuButtonPressed) 
                                     forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    if (self.delegate)
        self.currentSectionName = nil;
    
#ifdef PARTNER_ID
    [[[self customNavigationBar] menuButton] setHidden:NO];
#endif

    [super viewWillDisappear:animated];
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
       [[[self customNavigationBar] titleLabel] setText:self.partner.name];

    [partnerMenuButtons removeAllObjects];
    int i = 0;               
    NSArray * partnerSectionsArray = self.partnerSections;
    if(subSections != nil){
        PartnerMenuViewController *subMenu = [[PartnerMenuViewController alloc] 
                                              initWithNibName:@"PartnerMenuViewController" 
                                                       bundle:nil];
        subMenu.customNavigationBar = self.customNavigationBar;
        self.customNavigationBar.menuPage = subMenu;
        //subMenu.delegate is not set, we dont want to pop to root view controller
        subMenu.partner = self.partner;
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
         
       
        int isEven;
        for(Section *section in partnerSectionsArray) {
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
            buttonTitle.text = section.displayName;
            button.accessibilityLabel = section.displayName;
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
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",
                                SERVER_URL,section.imageUrl];
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 50, 50)];         
            [imgview setImageWithURL:[NSURL URLWithString:imgUrl]];
            [button addSubview:imgview];            
            
            i++;
        }
        
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
    Section * section = [partnerSectionsArray objectAtIndex:btn.tag];
    NSArray *aSubSections = section.subSections;
    if([aSubSections count] == 0) {
        if ([section.uiType isEqualToString:@"webview"]) {
         
        SubMenuViewController *subMenu=[[SubMenuViewController alloc] 
                                        initWithNibName:@"SubMenuViewController" bundle:nil];
        subMenu.customNavigationBar = self.customNavigationBar;
        if(section != nil) {
            subMenu.partner = self.partner;
            subMenu.section = section;
            NSString *urlString =  section.url;
            NSString *urlHeader = [urlString substringToIndex:7];
            NSString *sectionUrl = nil;
            if([urlHeader isEqualToString:URL_HEADER]) {
                sectionUrl = urlString;
            }
            else {  
                sectionUrl = [NSString stringWithFormat:@"%@/%@",
                              self.partner.webSiteUrl,
                              section.url];
            }
            subMenu.url = [sectionUrl stringByAppendingFormat:@"?&lat=%f&lon=%f",
                           [AppDelegate sharedDelegate].doubleLatitude,
                           [AppDelegate sharedDelegate].doubleLongitude];

        }
        [self.navigationController pushViewController:subMenu animated:YES];

        if ([section.name isEqual:@"Photos"])
        {
            dispatch_queue_t checkQueue =  dispatch_queue_create("check reachability", NULL);
            dispatch_async(checkQueue, ^{
                NSString * uploadUrl = [NSString stringWithFormat:@"%@%@",
                                        self.partner.webSiteUrl,
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
        else if ([section.name isEqual:@"Photos"]) {
            PhotoCategoriesViewController *controller = [PhotoCategoriesViewController new];
            controller.partner = self.partner;
            controller.customNavigationBar = self.customNavigationBar;
            [RequestHelper categoriesWithPartner:self.partner andSection:section andDelegate:controller];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
    else {
        subSections = aSubSections;
        self.currentSectionName = [NSString stringWithString:section.name];
        [self reloadMenu];        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    if([object isKindOfClass:[Partner class]]) {
        
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
}

#pragma mark -
#pragma mark store partner details 

- (void) restorePartnerDetails
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self setPartnerInfoDictionary:[userDefaults objectForKey:@"partnerDetails"]];
    if (self.partner.facebookAppId)
    {
        [AppDelegate sharedDelegate].facebookHelper.appId = self.partner.facebookAppId;
    }
    [self setPartnerSections:[userDefaults objectForKey:@"partnerSections"]];
}

- (void) savePartnerDetails {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.partner forKey:@"partnerDetails"];
    [userDefaults setObject:[self partnerSections] forKey:@"partnerSections"];
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark load partner info


- (void) loadPartnerDetails {
#ifdef PARTNER_ID
  
#endif
}

- (void) loadPartnerSections {

  /*  NSString *partnerId = [[self partnerInfoDictionary] objectForKey:@"id"];
    RWRequestHelper *helper = [[RWRequestHelper alloc] init];
    RWRequest *request = [helper sectionsRequestForPartnerWithId:partnerId];
    [helper performRequest:request withObserver:self];*/
}

- (void) loadPartnerLogo {
/*    NSString *imagePath = [NSString stringWithFormat:@"%@%@",SERVER_URL,[[self partnerInfoDictionary] objectForKey:@"image"]];
    [[ImageLoader instance] loadImageByUrl:[NSURL URLWithString:imagePath] observer:self];*/
}

#pragma mark -
#pragma mark RWRequestDelegate methods

/*- (void) requestDidFinishLoading:(RWRequest *) request {
    NSLog(@"response = %@",[request response]);
    if ([[request userInfo] isEqual:@"partnerDetails"]) {
        [self setPartnerInfoDictionary:[request response]];
        [self loadPartnerSections];
        [self loadPartnerLogo];
        NSLog(@"appid = %@",[[request response] objectForKey:@"facebook_app_id"]);
        if ([[request response] objectForKey:@"facebook_app_id"]) 
        {
            [AppDelegate sharedDelegate].facebookHelper.appId = [[request response]
                                                                 objectForKey:@"facebook_app_id"];
        }
    }
    else {
        [self setPartnerSections:[request response]];
        
        [self reloadMenu];        
        [self savePartnerDetails];        
        [activityIndicator stopAnimating];
    }

}
*/


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
    [activityIndicator release];
    activityIndicator = nil;

    [super viewDidUnload]; 
}

- (void)dealloc {
    [self cleanUp];
    [activityIndicator release];
    [super dealloc];
}
@end
