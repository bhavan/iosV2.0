//
//  EvensViewer.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "EventsViewer.h"
#import "Event.h"
#import "ActivityImageView.h"
#import "DDPageControlCustom.h"
#import "NSDate+Formatting.h"
#import "EventsView.h"

@interface EventsViewer ()
@property (nonatomic, retain) NSArray *events;
@end

static const CGFloat kEventsViewerIndicatorSpace = 11;
static const NSTimeInterval kEventDisplayingTime = 10;

@implementation EventsViewer

#pragma mark -
#pragma mark life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [pageControl setNumberOfPages:0];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(showCurrentEvent)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        [singleTapGesture release];
        
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(showNextEvent)];
        [leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:leftSwipeGesture];
        [leftSwipeGesture release];
        
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(showPreviousEvent)];
        [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:rightSwipeGesture];
        [rightSwipeGesture release];
    
        [eventPlace setText:nil];
        [eventName setText:nil];
        [eventTime setText:nil];
        [eventImage setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    UIImage *background = [UIImage imageNamed:@"event_viewer_background"];
    UIColor *detailsViewColor = [UIColor colorWithPatternImage:background];
    [detailsView setBackgroundColor:detailsViewColor];
    [eventImage setBackgroundColor:[UIColor clearColor]];
    [pageControl setIndicatorSpace:kEventsViewerIndicatorSpace];
}

#pragma mark -
#pragma mark public methods

- (void) displayEvents:(NSArray *) events
{
    if(events.count > 0)
    {     
        
        [self setEvents:events];
        [pageControl setNumberOfPages:[events count]];
        [self displayEventAtIndex:0];
   }
    else
    {
        [self hideFeaturedArea];        
    }
}

- (void)tickEvent
{
    [self showNextEvent];
}

- (void)hideFeaturedArea
{
    UIView *header =  _rootView.tableHeader;
    CGRect headerFrame = header.frame;
    headerFrame.size.height = 130;
    [_rootView.scrollView setContentOffset:CGPointMake(0, 215) animated:YES];

    
    [UIView beginAnimations:@"registerScrollDown" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    header.frame = headerFrame;
    [_rootView.tableView setTableHeaderView:header];
    [UIView commitAnimations];

    
}

#pragma mark -
#pragma mark private methods

- (void) displayEventAtIndex:(NSInteger) eventIndex
{
    if (eventIndex < [[self events] count])
    {
        currentEventIndex = eventIndex;
        [self updateTitlesWithEvent:[[self events] objectAtIndex:eventIndex]];
        [pageControl setCurrentPage:eventIndex];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(showNextEvent) withObject:nil afterDelay:kEventDisplayingTime];
    }
}

- (void) updateTitlesWithEvent:(Event *) event
{
    [eventName setText:event.title];
    [eventTime setText:nil];
    [eventPlace setText:[[event location] name]];
    NSString *urlStr = event.imageURL.absoluteString;
    UIView *header =  _rootView.tableHeader;
    CGRect headerFrame = header.frame;
    if(event.imageURL && urlStr.length > 3)
    {
        [eventImage setImageWithURL:[event imageURL]];
        headerFrame.size.height = 347;
          [_rootView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _isImagePresented = YES;
        
    }
    else
    {
        [eventImage setImage:nil];
        [eventImage.activityIndicator stopAnimating];
        headerFrame.size.height = 230;
          [_rootView.scrollView setContentOffset:CGPointMake(0, 115) animated:YES];
        _isImagePresented = NO;
    }
  
    [UIView beginAnimations:@"registerScrollDown" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    header.frame = headerFrame;
    [_rootView.tableView setTableHeaderView:header];
    [UIView commitAnimations];

    [eventTime setText:[event eventDateString]];
}

- (void)showCurrentEvent
{
    if(_delegate)
    {
        [_delegate eventTouched:[_events objectAtIndex:currentEventIndex]];
    }
}

- (void) showNextEvent
{
    if(currentEventIndex >= _events.count-1)
    {
        currentEventIndex = 0;
    }
    else
    {
        currentEventIndex++;
    }
    
    [self displayEventAtIndex:currentEventIndex];
}

- (void) showPreviousEvent
{
    NSInteger eventNumber = (currentEventIndex + self.events.count - 1) % self.events.count;
    [self displayEventAtIndex:eventNumber];
}

- (void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [eventImage release];
    [eventName release];
    [eventPlace release];
    [eventTime release];
    [pageControl release];
    [detailsView release];
    [self setRootView:nil];
    [_events release];;
    
    [super dealloc];
}


@end
