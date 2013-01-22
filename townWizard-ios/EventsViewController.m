//
//  EventsViewController.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewController.h"
#import "EventsView.h"
#import "EventCell.h"
#import "EventsViewer.h"
#import "EventSectionHeader.h"
#import "EventCategory.h"
#import "InputBar.h"
#import "PMCalendar.h"
#import "EventDetailsViewController.h"
#import "NSDate+Formatting.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extensions.h"

#define ALL_EVENTS_TEXT @"ALL EVENTS"

@interface EventsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, PMCalendarControllerDelegate>
{
    NSDate *currentStart;
    NSDate *currentEnd;
}


@property (nonatomic,retain)  NSDate *currentStart;
@property (nonatomic,retain)  NSDate *currentEnd;
@property (nonatomic,retain)  NSString *bannerUrlString;
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
- (NSArray *)currentCategotyEvents;

@end

static const NSInteger kEventsAlertTag = 700;

@implementation EventsViewController

@synthesize currentEnd;
@synthesize currentStart;

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


- (void)dealloc
{
    if(_categotiesList)
    {
        [_categotiesList release];
    }
    [featuredEventsViewer release];
    [eventsList release];
    [_eventsTypeButton release];
    [_calendarButton release];
    [_bannerImageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [featuredEventsViewer release];
    featuredEventsViewer = nil;
    [eventsList release];
    eventsList = nil;
    [self setEventsTypeButton:nil];
    [self setCalendarButton:nil];
    [self setBannerImageView:nil];
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentStart = nil;
    self.currentEnd = nil;
    self.trackedViewName = @"Events screen";
    self.calendar = [[[PMCalendarController alloc] initWithThemeName:@"apple calendar"] autorelease];
    self.calendar.delegate = self;
    self.calendar.mondayFirstDayOfWeek = NO;
    currentCategory = -1;
    [self.eventsTypeButton setTitle:ALL_EVENTS_TEXT forState:UIControlStateNormal];
    NSString *newDatePeriod = [NSDate stringFromPeriod:[NSDate date]
                                                   end:[NSDate date]];
    [self.calendarButton setTitle:newDatePeriod forState:UIControlStateNormal];
    self.sectionDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
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
    [eventDetails updateBannerImage:_bannerImageView.image urlString:_bannerUrlString];
    [eventDetails release];
}

#pragma mark -
#pragma mark events loading

- (void) loadFeaturedEvents
{
    featuredEventsViewer.delegate = self;
    [[RequestHelper sharedInstance] loadFeaturedEventUsingBlock:^(RKObjectLoader *loader)
     {
         [loader setOnDidFailWithError:^(NSError *error)
          {
              [self featuredEventsLoadingFailed:error];
          }];
         [loader setOnDidLoadObjects:^(NSArray *objects)
          {
              [self featuredEventsLoaded:objects];
          }];
     }];
}


- (void) loadEventsCategories
{
    [[RequestHelper sharedInstance] loadEventsCategoriesUsingBlock:^(RKObjectLoader *loader)
     {
         [loader setOnDidLoadObjects:^(NSArray *objects)
          {
              [self categoriesLoaded:objects];
          }];
     }];
}

- (void) loadTodayEvents
{
    self.currentStart = [NSDate date];
    self.currentEnd = [NSDate date];
    [self loadEventsWithDatePeriod:[NSDate date] endDate:[NSDate date]];
}

- (void)loadEventsWithDatePeriod:(NSDate *)startDate endDate:(NSDate *)endDate
{    
    [[RequestHelper sharedInstance] loadEventsWithDatePeriod:startDate end:endDate  delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self eventsLoaded:objects];
}

- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout id *)mappableData
{
    NSMutableDictionary* data = [[*mappableData objectForKey: @"ad"] mutableCopy];
    if(data && _bannerUrlString == nil)
    {
        _bannerUrlString = [[NSString alloc] initWithString:[data objectForKey:@"url"]];
        NSString *adImageUrl = [data objectForKey:@"banner"];
        [_bannerImageView setImageWithURL:[NSURL URLWithString:adImageUrl]];
    }
    [data release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

- (IBAction)bannerButtonPressed:(id)sender
{
    [[AppActionsHelper sharedInstance] openUrl:_bannerUrlString
                             fromNavController:self.navigationController];
}

- (IBAction)categoriesButtonPressed:(id)sender
{
    InputBar *actionSheet = [[InputBar alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    [actionSheet initWithDelegate:self andPickerValue:currentCategory+1];
    [actionSheet showInView:[self.view window]];
}

- (void)filterEventsByCategoryAndDate
{
    self.events = [self currentCategotyEvents];
    self.sections = [NSMutableDictionary dictionary];
    
    for (Event *event in self.events)
    {
        NSDate *startDate = [NSDate dateFromString:event.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDate = [NSDate dateFromString:event.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateRepresentingThisDay = [NSDate dateAtBeginningOfDayForDate:startDate];
        NSDate *dateRepresentingEndDay = [NSDate dateAtBeginningOfDayForDate:endDate];
        
        while ([dateRepresentingThisDay compare:dateRepresentingEndDay] != NSOrderedDescending)
        {
            NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
            if(self.currentStart == nil && self.currentEnd == nil)
            {
                self.currentStart = [NSDate date];
                self.currentEnd = [NSDate date];
            }
            BOOL isDateInPeriod = [NSDate isDate:dateRepresentingThisDay
                             inPeriodWithStart:self.currentStart
                                           end:self.currentEnd];
            if (eventsOnThisDay == nil && isDateInPeriod)
            {
                eventsOnThisDay = [NSMutableArray array];
                [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
            }            
            if(eventsOnThisDay)
            {
                [eventsOnThisDay addObject:event];               
            }
             dateRepresentingThisDay = [dateRepresentingThisDay dateByAddingDays:1];
        }
    }
    
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    [eventsList reloadData];
}


- (NSArray *)currentCategotyEvents
{
    NSArray *result;
    if(currentCategory == -1)
    {
        result = self.allEvents;
    }
    else
    {
        EventCategory *category = [self.categotiesList objectAtIndex:currentCategory];
        NSPredicate *pred = [NSPredicate predicateWithFormat:
                             [NSString stringWithFormat:@"(categoryName == '%@')", category.title]];
        result = [self.allEvents filteredArrayUsingPredicate:pred];
    }
    return result;
}

- (IBAction)dateSelectButtonPressed:(id)sender
{
    [self.calendar presentCalendarFromRect:CGRectMake(0, 0, 320, 0)
                                    inView:self.view
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                  animated:YES];
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController
           didChangePeriod:(PMPeriod *)newPeriod
{
    
}

- (BOOL)calendarControllerShouldDismissCalendar:(PMCalendarController *)calendarController
{
    if(!calendarController.isCalendarCanceled)
    {
        NSString *newDatePeriod = [NSDate stringFromPeriod:calendarController.period.startDate
                                                       end:calendarController.period.endDate];
        [self.calendarButton setTitle:newDatePeriod forState:UIControlStateNormal];
        self.currentStart = calendarController.period.startDate;
        self.currentEnd = calendarController.period.endDate;
        [self loadEventsWithDatePeriod:self.calendar.period.startDate
                               endDate:self.calendar.period.endDate];
    }
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

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
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
    if(!events || events.count == 0)
    {
        UIAlertView *alert = [UIAlertView showWithTitle:@"No Events Scheduled"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                     confirmButtonTitle:@"OK"];
        [alert setTag:1];
    }
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
    if ([alertView tag] == kEventsAlertTag)
    {
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
    if (cell == nil)
    {
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
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Event *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    [self eventTouched:event];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSString *title = [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
    CGRect headerFrame = CGRectMake(0, 0, [tableView frame].size.width, [tableView sectionHeaderHeight]);
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:headerFrame];
    [[header title] setText:[title uppercaseString]];
    return [header autorelease];
}


@end
