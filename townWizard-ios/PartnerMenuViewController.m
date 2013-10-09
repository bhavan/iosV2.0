//
//  PartnerMenuViewController.m
//  TownWizard-ios
//
//  Created by admin on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PartnerMenuViewController.h"

#import "Partner.h"
#import "Section.h"
#import "Appirater.h"
#import "UIImageView+WebCache.h"
#import "EventSectionHeader.h"
#import "SectionCell.h"
#import "ActivityImageView.h"
#import "FacebookHelper.h"
#import "AppDelegate.h"

#define ABOUT_SECTION_NAME @"about us"
#define HELP_SETCION_NAME @"help & support"
#define ADVERTISE_SECTION_NAME @"advertise with us"
#define CONTACTUS_SECTION_NAME @"contact us"

static NSInteger const kPartnerDetailsLoadingFailed = 500;
static NSInteger const kPartnerSectionsLoadingFailed = 501;

@interface PartnerMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation PartnerMenuViewController

#pragma mark -
#pragma mark life cycle

- (id) init
{
    if (self = [super init])
    {
        menu = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
  
    
    CGRect bgFrame = self.view.frame;
    bgFrame.origin = CGPointZero;
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:bgFrame
                                                         toView:self.view];
#ifdef PARTNER_ID
    _headerView.frame = CGRectMake(0, 0, 320, 84);
#endif
    
    if ([self partner] == nil)
    {
        [self loadPartnerDetails];
        [_delegate startUpdating];
    }
    else
    {
        [self updateWithPartner:self.partner];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:self.view.frame
                                                         toView:self.view];

}

- (void)viewDidUnload
{
    [sectionsList release]; sectionsList = nil;
    [activityIndicator release]; activityIndicator = nil;
    [searchField release]; searchField = nil;
    [partnerLogo release]; partnerLogo = nil;
    
    [self setHeaderView:nil];
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [activityIndicator release];
    [sectionsList release];
    [searchField release];
    [partnerLogo release];
    
    [menu release];
    
    [self setHeaderView:nil];
    [self setPartner:nil];
    
    [super dealloc];
}

#pragma mark - load partner info

- (void) updateWithPartner:(Partner *)updatedPartner
{
    self.partner = updatedPartner;
    self.trackedViewName = [[[updatedPartner locations] firstObject] city];
    
    [[RequestHelper sharedInstance] setCurrentPartner:updatedPartner];

    [self loadPartnerSections];
    [self trackPartnersInfoDisplayingGoogleAnalyticsEvent];
    
    NSString *imageURLString = [[self partner] headerImageUrl];
    if (imageURLString && ![imageURLString isEqualToString:@""])
    {
        [partnerLogo setImageWithURL:[NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@%@",
                                       SERVER_URL,
                                       [self.partner.headerImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

- (IBAction)aboutButtonPressed:(id)sender
{
    NSArray *infoSections = [menu objectForKey:@2];
    if(!infoSections)
    {
        NSDictionary *defaultMenu = [[AppActionsHelper sharedInstance] defaultMenu];
        infoSections = [defaultMenu objectForKey:@2];
    }
    for(Section *section in infoSections)
    {
        if([[section.name lowercaseString] isEqualToString:
            [ABOUT_SECTION_NAME lowercaseString]])
        {
            if ([[self delegate] respondsToSelector:@selector(menuSectionTapped:)])
            {
                [[self delegate] menuSectionTapped:section];
            }
            break;
        }
    }
}

#pragma mark - appearance

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - load partner details

- (void) loadPartnerDetails
{
    NSLog(@"load11");
#ifdef PARTNER_ID
    id successBlock = ^(id object) {
        [self partnerDetailsLoaded:object];
    };
    
    id failureBlock = ^(NSError *error) {
        [self showLoadingErrorWithTag:kPartnerDetailsLoadingFailed];
    };
    
    RequestHelper *helper = [RequestHelper sharedInstance];
    [helper loadPartnerDetails:[NSString stringWithFormat:@"%d",PARTNER_ID]
                    usingBlock:^(RKObjectLoader *loader) {
                        [loader setOnDidLoadObject:successBlock];
                        [loader setOnDidFailLoadWithError:failureBlock];
                    }];
#endif
}

- (void) loadPartnerSections
{
    id successBlock = ^(NSArray *objects) {
        [self sectionsLoaded:objects];
    };
    
    id failureBlock = ^(NSError *error) {
        [self showLoadingErrorWithTag:kPartnerSectionsLoadingFailed];
    };
    
    RequestHelper *helper = [RequestHelper sharedInstance];
    [helper loadSectionsUsingBlock:^(RKObjectLoader *loader) {
         [loader setOnDidLoadObjects:successBlock];
         [loader setOnDidFailLoadWithError:failureBlock];
     }];
}

#pragma mark -
#pragma mark callbacks

- (void) partnerDetailsLoaded:(Partner *) partner
{
    [self updateWithPartner:partner];
    if([partner.iTunesAppId hasPrefix:@"store"])
    {
        partner.iTunesAppId = [partner.iTunesAppId stringByReplacingOccurrencesOfString:@"store" withString:@""];
    }
    [Appirater setAppId:partner.iTunesAppId];
    [AppDelegate sharedDelegate].facebookHelper.appId = partner.facebookAppId;
    
    [[RequestHelper sharedInstance] setCurrentPartner:partner];
}

- (void) sectionsLoaded:(NSArray *) sections
{
    NSMutableArray *allSections = [NSMutableArray array];
    NSMutableArray *information = [NSMutableArray array];
    for(Section *aSection in sections)
    {
        if([self isInfoSection:aSection])
        {
            [information addObject:aSection];
        }
        else
        {
            [allSections addObject:aSection];
        }
    }
    if(allSections && allSections.count > 0)
    {
        [menu setObject:allSections forKey:@1];
    }
    if(information && information.count > 0)
    {
        [menu setObject:information forKey:@2];
        if ([self.partner.name isEqualToString:DEFAULT_PARTNER_NAME])
        {
            [[AppActionsHelper sharedInstance] setDefaultMenu:menu];
        }
    }
    [sectionsList reloadData];
    if ([_delegate respondsToSelector:@selector(sectionsUpdated:)])
    {
        [_delegate stopUpdating];
        [_delegate sectionsUpdated:sections];
    }
}

- (BOOL)isInfoSection:(Section *)section
{
    //sometimes method called wiht object of non Section class
    if (![section isKindOfClass:[Section class]]) {
        return NO;
    }
    
    section.name = [section.name stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    NSString *lowerName = [section.name lowercaseString];
    lowerName = [lowerName stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    if([lowerName isEqualToString:ABOUT_SECTION_NAME] ||
       [lowerName isEqualToString:HELP_SETCION_NAME] ||
       [lowerName isEqualToString:ADVERTISE_SECTION_NAME] ||
       [lowerName isEqualToString:CONTACTUS_SECTION_NAME])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -
#pragma mark actions


- (IBAction)changePartnerButtonPressed:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(changePartnerButtonTapped)])
    {
        [[self delegate] changePartnerButtonTapped];
    }
}

#pragma mark -
#pragma mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[menu allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id category = [[menu allKeys] objectAtIndex:section];
    return [[menu objectForKey:category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sectionCell";
    SectionCell *cell = (SectionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [SectionCell loadFromXib];
    }
    
    NSString *category = [[menu allKeys] objectAtIndex:indexPath.section];
    Section *section = [[menu objectForKey:category] objectAtIndex:indexPath.row];
    [cell updateWithSection:section];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id category = [[menu allKeys] objectAtIndex:indexPath.section];
    Section *section = [[menu objectForKey:category] objectAtIndex:indexPath.row];
    if ([[self delegate] respondsToSelector:@selector(menuSectionTapped:)])
    {
        [[self delegate] menuSectionTapped:section];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerFrame = CGRectMake(0, 0, [tableView frame].size.width, [tableView sectionHeaderHeight]);
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:headerFrame];
    NSNumber *categoryIndex = [[menu allKeys] objectAtIndex:section];
    [[header title] setText:[self categoryName:categoryIndex]];
    header.title.textColor = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.000];
    return [header autorelease];
}

#pragma mark -
#pragma mark test

- (NSArray *)predefinedSectionsNames
{
    return @[@"Help & Support",
             @"About TownWizard",
             @"Advertise with TownWizard",
             @"Contact TownWizard"];
}

- (NSString *) categoryName:(NSNumber *) categoryIndex
{
    switch ([categoryIndex intValue])
    {
        case 1:
        {
            return @"powered by townwizard";
            
        }
        case 2: return @"";
        default: return nil;
    }
}

- (NSArray *) getPredefinedSections
{
    NSArray *names = [self predefinedSectionsNames];
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[names count]];
    for (NSString *sectionName in names)
    {
        Section *section = [[Section alloc] init];
        [section setName:sectionName];
        [section setDisplayName:sectionName];
        [sections addObject:section];
        [section release];
    }
    return sections;
}

#pragma amrk - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![self isPartnerApplication] && buttonIndex == 0) {
        [self changePartnerButtonPressed:nil];
    }
    else {
        [self reloadDataWithTag:[alertView tag]];
    }
}

#pragma mark - private methods

- (BOOL)isPartnerApplication {
#ifdef PARTNER_ID
    return YES;
#else
    return NO;
#endif
}

- (void)showLoadingErrorWithTag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data connectivity"
                                                    message:@"Do you want to retry?"
                                                   delegate:self
                                          cancelButtonTitle:[self isPartnerApplication] ? nil : @"Cancel"
                                          otherButtonTitles:@"Retry", nil];
    [alert setTag:tag];
    [alert show];
    
    [alert release];
}

- (void)reloadDataWithTag:(NSInteger)tag {
    if (tag == kPartnerDetailsLoadingFailed) {
        [self loadPartnerDetails];
    }
    else if (tag == kPartnerSectionsLoadingFailed) {
        [self loadPartnerSections];
    }
}

- (void)trackPartnersInfoDisplayingGoogleAnalyticsEvent {
    GoogleAnalyticsEvent *analyticsEvent = [[GoogleAnalyticsEvent new] autorelease];
    [analyticsEvent setEventName:@"splash-screen"];
    [analyticsEvent setEventDescription:@"Show partner info"];
    [analyticsEvent send];
}

@end
