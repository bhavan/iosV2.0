//
//  EventsViewController.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewController.h"
#import "EventsControllerView.h"
#import "EventCell.h"
#import "EventsViewer.h"
#import "EventSectionHeader.h"
#import "EventCategory.h"
#import "InputBar.h"
#import "PMCalendar.h"

#import "UIView+Extensions.h"

#define ALL_EVENTS_TEXT @"ALL EVENTS"

@interface EventsViewController () <UITableViewDataSource, UIAlertViewDelegate, PMCalendarControllerDelegate>
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, strong) PMCalendarController *calendar;
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
   // [self loadAllEvents];
    [self loadTodayEvents];
    [self loadEventsCategories];
#warning Set features count to 5
    [self loadFeaturedEvents];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [featuredEventsViewer release];
    [eventsList release];
    [_eventsTypeButton release];
    [_calendarButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [featuredEventsViewer release];
    featuredEventsViewer = nil;
    [eventsList release];
    eventsList = nil;
    [self setEventsTypeButton:nil];
    [self setCalendarButton:nil];
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        self.calendar = [[PMCalendarController alloc] initWithThemeName:@"apple calendar"];
    self.calendar.delegate = self;
    self.calendar.mondayFirstDayOfWeek = NO;
    currentCategory = -1;
    [self.eventsTypeButton setTitle:ALL_EVENTS_TEXT forState:UIControlStateNormal];
    [self.calendarButton setTitle:@"TODAY" forState:UIControlStateNormal];
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

- (void) loadEventsCategories
{
    [[RequestHelper sharedInstance] loadEventsCategoriesUsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects){
            [self categoriesLoaded:objects];
        }];
        [loader setOnDidFailWithError:^(NSError *error){
            // [self eventsLoadingFailed:error];
        }];
    }];
}

- (void) loadTodayEvents
{
    [self loadEventsWithDatePeriod:[NSDate date] endDate:[NSDate date]];
}

- (void)loadEventsWithDatePeriod:(NSDate *)startDate endDate:(NSDate *)endDate
{
    [[RequestHelper sharedInstance] loadEventsWithDatePeriod:startDate end:endDate
                                                  UsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidLoadObjects:^(NSArray *objects){
            [self eventsLoaded:objects];
        }];
        [loader setOnDidFailWithError:^(NSError *error){
            [self eventsLoadingFailed:error];
        }];
    }];

}

- (IBAction)categoriesButtonPressed:(id)sender {
    // if(_categotiesList.count > 0)
    // {
    InputBar *actionSheet = [[InputBar alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    [actionSheet initWithDelegate:self andPickerValue:currentCategory+1];
    [actionSheet showInView:[self.view window]];
    //  }
}

- (void)filterEventsByCategory
{
    if(currentCategory == -1)
    {
        self.events = self.allEvents;
    }
    else
    {
         EventCategory *category = [self.categotiesList objectAtIndex:currentCategory];
        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(categoryName == '%@')", category.title]];
        
        self.events = [self.allEvents filteredArrayUsingPredicate:pred];
    }
     [eventsList reloadData];
    
}

- (IBAction)dateSelectButtonPressed:(id)sender
{
    [self.calendar presentCalendarFromRect:CGRectMake(0, 115, 320, 0)
                           inView:self.view
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *newDatePeriod = [NSString stringWithFormat:@"%@ - %@"
                              , [newPeriod.startDate dateStringWithFormat:@"LLL dd"]
                              , [newPeriod.endDate dateStringWithFormat:@"LLL dd"]];
    [self.calendarButton setTitle:newDatePeriod forState:UIControlStateNormal];
}

- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController
{
    [self loadEventsWithDatePeriod:self.calendar.period.startDate
                           endDate:self.calendar.period.endDate];
    return YES;
}

#pragma mark -
#pragma mark UIPickerView Delegate/Datasource methods

- (void)actionSheet:(UIActionSheet *)aActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = ALL_EVENTS_TEXT;
    if(currentCategory >= 0)
    {
    EventCategory *category = [self.categotiesList objectAtIndex:currentCategory];
        title = [category.title uppercaseString];
    }
    [self.eventsTypeButton setTitle:title forState:UIControlStateNormal];
    [self filterEventsByCategory];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.categotiesList)
    {
        return self.categotiesList.count+1;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return ALL_EVENTS_TEXT;
    }
    else
    {
        EventCategory *category = [self.categotiesList objectAtIndex:row-1];
        return [category.title uppercaseString];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        currentCategory = -1;
    }
    else
    {
        currentCategory = row-1;
    }
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
    [self setAllEvents:events];
    [self filterEventsByCategory];
}

- (void) categoriesLoaded:(NSArray *)categories
{
    [self setCategotiesList:categories];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == kEventsAlertTag) {
        [self loadTodayEvents];
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
    [featuredEventsViewer setRootView:self.view];
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
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"EEEE dd LLL"];
    NSString *strDate = [[dateFormat stringFromDate:[NSDate date]] uppercaseString];
    [dateFormat release];
    [[header title] setText:strDate];
    return header;
}



@end
