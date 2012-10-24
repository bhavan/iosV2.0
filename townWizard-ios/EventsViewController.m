//
//  EventsViewController.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewController.h"
#import "RequestHelper.h"
#import "UIView+Extensions.h"
#import "EventCell.h"

@interface EventsViewController () <RKObjectLoaderDelegate>
@property (nonatomic, retain) NSArray *events;
@end

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
    
}

- (void) loadAllEvents
{
    [[RequestHelper sharedInstance] loadEventsWithDelegate:self];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"FAIL = %@",error);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects = %@",objects);
    
    [self setEvents:objects];
    [eventsList reloadData];
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
    }
    
    
    return cell;
}

@end
