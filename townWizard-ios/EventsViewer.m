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

@implementation EventsViewer

#pragma mark -
#pragma mark life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [pageControl setNumberOfPages:0];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurrentEvent)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
        [doubleTapGesture release];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNextEvent)];
        singleTapGesture.numberOfTapsRequired = 1;
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];

        [self addGestureRecognizer:singleTapGesture];
        [singleTapGesture release];
        
        
    
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

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showNextEvent];
}*/

#pragma mark -
#pragma mark public methods

- (void) displayEvents:(NSArray *) events
{
    if(events.count > 0)
    {     
        
        [self setEvents:events];
        [pageControl setNumberOfPages:[events count]];
        currentTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                        target:self
                                                      selector:@selector(tickEvent)
                                                      userInfo:nil
                                                       repeats:YES];
        [self displayEventAtIndex:0];    
   }
}

- (void)tickEvent
{
    [self showNextEvent];
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
    if (currentEventIndex > 0) {
        [self displayEventAtIndex:currentEventIndex - 1];
    }
}

- (void) dealloc
{
    [currentTimer invalidate];
    currentTimer = nil;
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
