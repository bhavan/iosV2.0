//
//  EvensViewer.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewer.h"
#import "Event.h"

@interface EventsViewer ()
@property (nonatomic, retain) NSArray *events;
@end

@implementation EventsViewer

#pragma mark -
#pragma mark life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [pageControl setNumberOfPages:0];
    }
    return self;
}

- (void) dealloc
{
    [eventImage release];
    [eventName release];
    [eventPlace release];
    [eventTime release];
    [pageControl release];
    
    [self setEvents:nil];

    [super dealloc];
}

#pragma mark -
#pragma mark public methods

- (void) displayEvents:(NSArray *) events
{
    [self setEvents:events];
    [pageControl setNumberOfPages:[events count]];
    [self displayEventAtIndex:0];
}

#pragma mark -
#pragma mark private methods

- (void) displayEventAtIndex:(NSInteger) eventIndex
{
    if (eventIndex < [[self events] count]) {
        Event *event = [[self events] objectAtIndex:eventIndex];
        [pageControl setCurrentPage:eventIndex];
    }    
}

@end
