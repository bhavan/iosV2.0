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

#import "UIImageView+WebCache.h"

#import "EventSectionHeader.h"
#import "SectionCell.h"

@interface PartnerMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain, readwrite) NSArray *sections;
@end

@implementation PartnerMenuViewController

#pragma mark -
#pragma mark life cycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if ([self partner] == nil) {
        [self loadPartnerDetails];
    }
    else {
        [self loadPartnerSections];
    }
}

- (void)viewDidUnload
{
    [sectionsList release]; sectionsList = nil;
    [activityIndicator release]; activityIndicator = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [activityIndicator release];
    [sectionsList release];
    
    [self setSections:nil];

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
    [[RequestHelper sharedInstance] loadSectionsUsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects) {
            [self sectionsLoaded:objects];
        }];
    }];
}

#pragma mark -
#pragma mark callbacks

- (void) partnerDetailsLoaded:(Partner *) partner
{
    [[RequestHelper sharedInstance] setCurrentPartner:partner];
    [self loadPartnerSections];
}

- (void) sectionsLoaded:(NSArray *) sections
{
//    [self setSections:sections];
    NSMutableArray *loadedSections = [NSMutableArray array];
    [loadedSections addObjectsFromArray:sections];
    [loadedSections addObjectsFromArray:[self getPredefinedSections]];
    [self setSections:loadedSections];
    
    [sectionsList reloadData];
    if ([_delegate respondsToSelector:@selector(sectionsUpdated:)]) {
        [_delegate sectionsUpdated:sections];
    }
}

#pragma mark -
#pragma mark actions

- (IBAction)changePartnerButtonPressed:(id)sender
{
    if ([[self delegate] respondsToSelector:@selector(changePartnerButtonTapped)]) {
        [[self delegate] changePartnerButtonTapped];
    }
}

#pragma mark -
#pragma mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sectionCell";
    SectionCell *cell = (SectionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [SectionCell loadFromXib];
    }
    
    Section *section = [[self sections] objectAtIndex:indexPath.row];
    [cell updateWithSection:section];
    
    return cell;    
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section *section = [[self sections] objectAtIndex:indexPath.row];
    if ([[self delegate] respondsToSelector:@selector(menuSectionTapped:)]) {
        [[self delegate] menuSectionTapped:section];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerFrame = CGRectMake(0, 0, [tableView frame].size.width, [tableView sectionHeaderHeight]);
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:headerFrame];
    [[header title] setText:@"CATEGORY HEADING"];
    return header;

}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([searchField isFirstResponder]) {
        [searchField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark test

- (NSArray *) predefinedSectionsNames
{
  return @[
            @"News Feed",
            @"Events",
            @"Offers",
            @"Nightlife",
            @"Entertainment",
            @"Town Dirrectory",
            @"Your Profile",
            @"Your Saved Items",
            @"Settings & Preferences",
            @"Best in Town Lists",
            @"Talk of the Town Blog",
            @"Ratings & Reviews",
            @"Check-ins & Hotspots",
            @"Help & Support",
            @"About TownWizard",
            @"Advertise with TownWizard",
            @"Contact TownWizard"
        ];
}

- (NSArray *) getPredefinedSections
{
    NSArray *names = [self predefinedSectionsNames];
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[names count]];
    for (NSString *sectionName in names) {
        Section *section = [[Section alloc] init];
        [section setName:sectionName];
        [section setDisplayName:sectionName];
        [sections addObject:section];
        [section release];
    }
    return sections;
}

@end
