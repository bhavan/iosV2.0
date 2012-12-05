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

@interface EventsViewer ()
@property (nonatomic, retain) NSArray *events;
@end

static const CGFloat kEventsViewerIndicatorSpace = 11;

@implementation EventsViewer

#pragma mark -
#pragma mark life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [pageControl setNumberOfPages:0];
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextEvent)];
        [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:leftSwipe];

        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousEvent)];
        [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:rightSwipe];
        
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

- (void) dealloc
{
    [eventImage release];
    [eventName release];
    [eventPlace release];
    [eventTime release];
    [pageControl release];
    [detailsView release];
    
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
        currentEventIndex = eventIndex;
        [self updateTitlesWithEvent:[[self events] objectAtIndex:eventIndex]];
        [pageControl setCurrentPage:eventIndex];
    }    
}

- (void) updateTitlesWithEvent:(Event *) event
{
    [eventName setText:[event title]];
    [eventTime setText:nil];
    [eventPlace setText:[[event location] address]];
    NSString *urlStr = event.imageURL.absoluteString;
    if(event.imageURL && urlStr.length > 3)
    {
    [eventImage setImageWithURL:[event imageURL]];
        [UIView beginAnimations:@"registerScrollDown" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        self.rootView.transform = CGAffineTransformMakeTranslation(0, 0);
        CGRect theFrame = self.rootView.frame;
        if(theFrame.size.height > 480)
        {
           
        theFrame.size.height -= 110.f;
        self.rootView.frame = theFrame;
        }
        
        [UIView commitAnimations];
         _isImagePresented = YES;
    }
    else
    {
        
        [eventImage.activityIndicator stopAnimating];
        [UIView beginAnimations:@"registerScrollUp" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        self.rootView.transform = CGAffineTransformMakeTranslation(0, -110);
        CGRect theFrame = self.rootView.frame;
        if(theFrame.size.height <= 480)
        {
            
            theFrame.size.height += 110.f;
            self.rootView.frame = theFrame;
        }
        [UIView commitAnimations];
        _isImagePresented = NO;
      //  UITableView *rootTableView = (UITableView *)_rootView;
       // [rootTableView setContentOffset:CGPointMake(0, 110)];
    }
    [eventTime setText:[self eventDateString:event]];
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

- (NSString *) eventDateString:(Event *) event
{
    NSDate *start = [NSDate dateFromString:event.startTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *end = [NSDate dateFromString:event.endTime dateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *startTimeString = [NSDate stringFromDate:start dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    NSString *endTimeString = [NSDate stringFromDate:end dateFormat:@"h:mma" localeIdentifier:@"en_US"];
    return [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
}

@end
