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
#import "EventDetailsViewController.h"
#import "NSDate+Formatting.h"

#import "UIView+Extensions.h"

#define ALL_EVENTS_TEXT @"ALL EVENTS"

@interface EventsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, PMCalendarControllerDelegate>
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSArray *allFeaturedEvents;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, strong) PMCalendarController *calendar;
@property (nonatomic, retain) NSDateFormatter *sectionDateFormatter;
@property (nonatomic, retain) NSArray *sortedDays;

- (void) loadTodayEvents;
- (void)loadEventsWithDatePeriod:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)filterEventsByCategoryAndDate;

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
    NSString *newDatePeriod = [self stringFromPeriod:[NSDate date]
                                                 end:[NSDate date]];
    [self.calendarButton setTitle:newDatePeriod forState:UIControlStateNormal];
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateFormat:@"EEEE LLL dd"];
    [self loadTodayEvents];
    [self loadEventsCategories];
    [self loadFeaturedEvents];
}

- (void)eventTouched:(Event *)event
{
    EventDetailsViewController *eventDetails = [EventDetailsViewController new];
    [eventDetails loadWithEvent:event];
    [self.navigationController pushViewController:eventDetails animated:YES];
    [eventDetails release];
    
}


#pragma mark -
#pragma mark events loading

- (void) loadFeaturedEvents
{
    featuredEventsViewer.delegate = self;
    [[RequestHelper sharedInstance] loadFeaturedEventUsingBlock:^(RKObjectLoader *loader) {
        [loader setOnDidFailWithError:^(NSError *error){
            [self featuredEventsLoadingFailed:error];
        }];
        [loader setOnDidLoadObjects:^(NSArray *objects){
            [self featuredEventsLoaded:objects];
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

- (void)filterEventsByCategoryAndDate
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
    
    self.sections = [NSMutableDictionary dictionary];
    for (Event *event in self.events)
    {
        NSDate *startDate = [NSDate dateFromString:event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateRepresentingThisDay = [NSDate dateAtBeginningOfDayForDate:startDate];
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil)
        {
            eventsOnThisDay = [NSMutableArray array];
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        [eventsOnThisDay addObject:event];
    }
    
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    [eventsList reloadData];
    
}

- (IBAction)dateSelectButtonPressed:(id)sender
{
    [self.calendar presentCalendarFromRect:CGRectMake(0, 0, 320, 0)
                                    inView:self.view
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                  animated:YES];
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    
}

- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController
{
    if(!calendarController.isCalendarCanceled)
    {
        NSString *newDatePeriod = [self stringFromPeriod:calendarController.period.startDate
                                                     end:calendarController.period.endDate];
        [self.calendarButton setTitle:newDatePeriod forState:UIControlStateNormal];
        [self loadEventsWithDatePeriod:self.calendar.period.startDate
                               endDate:self.calendar.period.endDate];
    }
    return YES;
}

- (NSString *)stringFromPeriod:(NSDate *)start end:(NSDate *)end
{
    if([[start dateStringWithFormat:@"LLL dd"] isEqualToString:[[NSDate date] dateStringWithFormat:@"LLL dd"]] && [[end dateStringWithFormat:@"LLL dd"] isEqualToString:[[NSDate date] dateStringWithFormat:@"LLL dd"]])
    {
        return @"TODAY";
    }
    else
    {
        NSString *newDatePeriod = [NSString stringWithFormat:@"%@ - %@"
                                   , [start dateStringWithFormat:@"LLL dd"]
                                   , [end dateStringWithFormat:@"LLL dd"]];
        return newDatePeriod;
    }
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
    [self filterEventsByCategoryAndDate];
    
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
    [self filterEventsByCategoryAndDate];
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
    _allFeaturedEvents = featuredEvents;
    [featuredEventsViewer setRootView:eventsList];
    [featuredEventsViewer displayEvents:_allFeaturedEvents];
    //  [featuredEventsViewer displayEvents:@[]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EventCell";
    EventCell *cell = (EventCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [EventCell loadFromXib];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Event *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    [cell updateWithEvent:event];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailsViewController *eventDetails = [EventDetailsViewController new];
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Event *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    [eventDetails loadWithEvent:event];
    
    [self.navigationController pushViewController:eventDetails animated:YES];
    [eventDetails release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSString *title = [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
    CGRect headerFrame = CGRectMake(0, 0, [tableView frame].size.width, [tableView sectionHeaderHeight]);
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:headerFrame];
    [[header title] setText:[title uppercaseString]];
    return header;
}



@end
