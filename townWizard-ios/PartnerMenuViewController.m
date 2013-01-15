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
    }
    else {
        [self updateWithPartner:self.partner];
    }
}

- (void) updateWithPartner:(Partner *)updatedPartner
{
    self.partner = updatedPartner;
    [[RequestHelper sharedInstance] setCurrentPartner:updatedPartner];
    [self loadPartnerSections];
    NSString *imageURLString = [[self partner] headerImageUrl];
    if (imageURLString && ![imageURLString isEqualToString:@""])
    {
        [partnerLogo setImageWithURL:[NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@%@",
                                       SERVER_URL,
                                       self.partner.headerImageUrl]]];
    }    
}

- (IBAction)aboutButtonPressed:(id)sender
{
    NSArray *infoSections = [menu objectForKey:@2];
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


- (void)viewDidUnload
{
    [sectionsList release];
    sectionsList = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [searchField release];
    searchField = nil;
    [partnerLogo release];
    partnerLogo = nil;
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
    [_headerView release];
    [super dealloc];
}


#pragma mark -
#pragma mark autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark loading

- (void) loadPartnerDetails
{
#ifdef PARTNER_ID
    [[RequestHelper sharedInstance] loadPartnerDetails:[NSString stringWithFormat:@"%d",PARTNER_ID]
                                            usingBlock:^(RKObjectLoader *loader) {
                                                [loader setOnDidLoadObject:^(id object){
                                                    [self partnerDetailsLoaded:object];
                                                }];
                                            }];
#endif
}

- (void) loadPartnerSections
{
    [[RequestHelper sharedInstance] loadSectionsUsingBlock:^(RKObjectLoader *loader)
    {
        [loader setOnDidLoadObjects:^(NSArray *objects)
        {
            [self sectionsLoaded:objects];
        }];
        [loader setOnDidFailWithError:^(NSError *error)
        {
            NSLog(@"%@",error.localizedDescription);
            [self changePartnerButtonPressed:nil];
        }];
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
    [self loadPartnerSections];
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
    }    
    [sectionsList reloadData];
    if ([_delegate respondsToSelector:@selector(sectionsUpdated:)])
    {
        [_delegate sectionsUpdated:sections];
    }
}

- (BOOL)isInfoSection:(Section *)section
{
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
    return [header autorelease];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([searchField isFirstResponder])
    {
        [searchField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark test

- (NSArray *) predefinedSectionsNames
{
    return @[
    //            @"News Feed",
    //            @"Events",
    //            @"Offers",
    //            @"Nightlife",
    //            @"Entertainment",
    //            @"Town Dirrectory",
    //            @"Your Profile",
    //            @"Your Saved Items",
    //            @"Settings & Preferences",
    //            @"Best in Town Lists",
    //            @"Talk of the Town Blog",
    //            @"Ratings & Reviews",
    //            @"Check-ins & Hotspots",
    @"Help & Support",
    @"About TownWizard",
    @"Advertise with TownWizard",
    @"Contact TownWizard"
    ];
}

- (NSString *) categoryName:(NSNumber *) categoryIndex
{
    switch ([categoryIndex intValue])
    {
        case 1: return @"Sections";
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

@end
