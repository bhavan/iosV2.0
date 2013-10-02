//
//  EventsHelper.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/23/13.
//
//

#import "EventsHelper.h"
#import "NSDate+Formatting.h"
#import "NSDate+Helpers.h"
#import "EventCategory.h"
#import "Event.h"

#define EVENT_SORT_DATE_FORMAT @"yyyy-MM-dd H:mm:ss"

@implementation EventsHelper

@synthesize currentEnd;
@synthesize currentStart;

static const NSInteger kEventsAlertTag = 700;

- (id)initWithDelegate:(id<EventsHelperDelegate>)aDelegate
{
    self = [super init];
    if(self)
    {
        delegate = aDelegate;
        self.currentStart = nil;
        self.currentEnd = nil;
        _currentCategory = -1;
    }
    return self;
}

#pragma mark -
#pragma mark events loading

- (void)loadEventsData
{
    [self loadTodayEvents];
    [self loadEventsCategories];
    [self loadFeaturedEvents];
}

- (void) loadFeaturedEvents
{
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
        adImageUrl = [adImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [delegate bannerFounded:[NSURL URLWithString:adImageUrl]];
    }
    [data release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [delegate eventsLoadingFailed:error];
}

#pragma mark -
#pragma mark featured events loading callback methods

- (void ) featuredEventsLoadingFailed:(NSError *) error
{
    [delegate eventsLoadingFailed:error];
}

- (void) featuredEventsLoaded:(NSArray *) featuredEvents
{
    NSLog(@"featured loaded %@",featuredEvents);
    _allFeaturedEvents = featuredEvents;
    [delegate didLoadFeaturedEvents:featuredEvents];
}

#pragma mark -
#pragma mark events loading callback methods

- (void) eventsLoadingFailed:(NSError *) error
{
    [delegate eventsLoadingFailed:error];
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

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == kEventsAlertTag)
    {
        [self loadTodayEvents];
    }
}

- (void) categoriesLoaded:(NSArray *)categories
{
    [self setCategotiesList:categories];
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
    for (NSDate *day in self.sortedDays)
    {
        NSArray *days = [self.sections objectForKey:day];
        NSArray *sortedDays = [days sortedArrayUsingSelector:@selector(compareByDate:)];
        [self.sections setObject:sortedDays forKey:day];
    }    
    [delegate eventsFiltered];
}

- (Event *)eventForIndexPath:(NSIndexPath *)indexPath
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    Event *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    return event;
}


- (NSArray *)currentCategotyEvents
{
    NSArray *result;
    if(_currentCategory == -1)
    {
        result = self.allEvents;
    }
    else
    {
        EventCategory *category = [self.categotiesList objectAtIndex:_currentCategory];
        NSPredicate *pred = [NSPredicate predicateWithFormat:
                             [NSString stringWithFormat:@"(categoryName == '%@')", category.title]];
        result = [self.allEvents filteredArrayUsingPredicate:pred];
    }
    return result;
}

- (void)dealloc
{
    [self setCategotiesList:nil];
    [self setEvents:nil];
    [self setAllEvents:nil];
    [self setAllFeaturedEvents:nil];
    [self setCurrentStart:nil];
    [self setCurrentEnd:nil];
    [self setSortedDays:nil];
    [self setBannerUrlString:nil];
    [super dealloc];
}

@end
