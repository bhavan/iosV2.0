//
//  EventsHelper.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/23/13.
//
//

#import <Foundation/Foundation.h>

@protocol EventsHelperDelegate <NSObject>

- (void)eventsFiltered;
- (void)didLoadFeaturedEvents:(NSArray *)events;
- (void)bannerFounded:(NSURL *)bannerUrl;

- (void)eventsLoadingFailed:(NSError *)error;
@end

@interface EventsHelper : NSObject <RKObjectLoaderDelegate>
{
    id<EventsHelperDelegate> delegate;
    NSDate *currentStart;
    NSDate *currentEnd;
}

@property (nonatomic, retain) NSArray *categotiesList;
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSArray *allFeaturedEvents;
@property (nonatomic, retain) NSDate *currentStart;
@property (nonatomic, retain) NSDate *currentEnd;
@property (nonatomic, assign) NSInteger currentCategory;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSArray *sortedDays;
@property (nonatomic,retain)  NSString *bannerUrlString;

- (id)initWithDelegate:(id<EventsHelperDelegate>)aDelegate;
- (void)loadTodayEvents;
- (void)loadEventsCategories;
- (void)loadFeaturedEvents;
- (void)loadEventsWithDatePeriod:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)filterEventsByCategoryAndDate;
- (NSArray *)currentCategotyEvents;
- (Event *)eventForIndexPath:(NSIndexPath *)indexPath;
- (void)loadEventsData;

@end



