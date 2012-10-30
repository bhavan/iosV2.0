//
//  EventsViewController.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewController.h"

#import "EventCell.h"
#import "EventsViewer.h"
#import "EventSectionHeader.h"

#import "UIView+Extensions.h"

@interface EventsViewController () <UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, retain) NSArray *events;
@end

static const NSInteger kEventsAlertTag = 700;

@implementation EventsViewController

#pragma mark -
#pragma mark life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAllEvents];
    [self loadFeaturedEvents];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [featuredEventsViewer release];
    [eventsList release];
    [super dealloc];
}

- (void)viewDidUnload {
    [featuredEventsViewer release]; featuredEventsViewer = nil;
    [eventsList release]; eventsList = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark events loading

- (void) loadFeaturedEvents
{
    [[RequestHelper sharedInstance] loadFeaturedEventUsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidFailWithError:^(NSError *error){
            [self featuredEventsLoadingFailed:error];
        }];
        [loader setOnDidLoadObjects:^(NSArray *objects){
            [self featuredEventsLoaded:objects];
        }];
    }];
}

- (void) loadAllEvents
{    
    [[RequestHelper sharedInstance] loadEventsUsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects){
            [self eventsLoaded:objects];
        }];
        [loader setOnDidFailWithError:^(NSError *error){
            [self eventsLoadingFailed:error];
        }];
    }];
}

#pragma mark -
#pragma mark events loading callback methods

- (void) eventsLoadingFailed:(NSError *) error
{
    UIAlertView *alert = [UIAlertView showWithTitle:@"Error"
                                            message:@"Evens loading error. Do you want to try again"
                                           delegate:self
                                  cancelButtonTitle:@"NO"
                                 confirmButtonTitle:@"YES"];
    [alert setTag:kEventsAlertTag];
}

- (void) eventsLoaded:(NSArray *) events
{
    [self setEvents:events];
    [eventsList reloadData];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == kEventsAlertTag) {
        [self loadAllEvents];
    }
}

#pragma mark -
#pragma mark featured events loading callback methods

- (void ) featuredEventsLoadingFailed:(NSError *) error
{
    NSLog(@"erroro = %@",error);
}

- (void) featuredEventsLoaded:(NSArray *) featuredEvents
{
    NSLog(@"featured loaded %@",featuredEvents);
    [featuredEventsViewer displayEvents:featuredEvents];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self events] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EventCell";
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [EventCell loadFromXib];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell updateWithEvent:[[self events] objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerFrame = CGRectMake(0, 0, [tableView frame].size.width, [tableView sectionHeaderHeight]);
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:headerFrame];
    [[header title] setText:@"MONDAY 02 FEB"];
    return header;
}



@end
