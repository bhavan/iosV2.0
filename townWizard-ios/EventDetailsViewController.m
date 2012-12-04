//
//  EventDetailsViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/4/12.
//
//

#import "EventDetailsViewController.h"
#import "Event.h"
#import "Location.h"

@interface EventDetailsViewController ()

@end



@implementation EventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:_topDetailView];
    if(_event)
    {
        [self loadWithEvent:_event];
    }
}

- (void)loadWithEvent:(Event *)event
{
    _event = event;
    _topDetailView.eventTitleLabel.text = event.title;
    _topDetailView.eventAdress.text = event.location.address;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_scrollView release];
    [_topDetailView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTopDetailView:nil];
    [super viewDidUnload];
}
@end
