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
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(showNextEvent)];
        [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(showPreviousEvent)];
        [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:rightSwipe];
        [leftSwipe release];
        [rightSwipe release];
                
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_delegate)
    {
        [_delegate eventTouched:[_events objectAtIndex:currentEventIndex]];
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
    [self setEvents:nil];
    
    [super dealloc];
}

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
    UIView *header =  _rootView.tableHeaderView;
    CGRect headerFrame = header.frame;
    if(event.imageURL && urlStr.length > 3)
    {
        [eventImage setImageWithURL:[event imageURL]];
        headerFrame.size.height = 347;
        _isImagePresented = YES;
    }
    else
    {
        [eventImage setImage:nil];
        [eventImage.activityIndicator stopAnimating];
        headerFrame.size.height = 227;
        _isImagePresented = NO;
    }
  
    [UIView beginAnimations:@"registerScrollDown" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    header.frame = headerFrame;
    [_rootView setTableHeaderView:header];
    [UIView commitAnimations];

    [eventTime setText:[event eventDateString]];
}

- (void) showNextEvent
{
    if (currentEventIndex < [[self events] count] - 1) {
        [self displayEventAtIndex:currentEventIndex + 1];
    }
}

- (void) showPreviousEvent
{
    if (currentEventIndex > 0) {
        [self displayEventAtIndex:currentEventIndex - 1];
    }
}



@end
