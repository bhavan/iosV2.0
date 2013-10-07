//
//  VideosViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "VideosListViewController.h"
#import "ImageCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "SubMenuViewController.h"
#import "Partner.h"
#import "Section.h"
#import "VideoViewController.h"
#import "RequestHelper.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString *const kYoutubeThumbnailFormat = @"http://img.youtube.com/vi/%@/0.jpg";

@interface VideosListViewController ()
    <UITableViewDataSource,
    UITableViewDelegate,
    RKObjectLoaderDelegate>

@property (nonatomic, retain) NSArray *videos;

@end

@implementation VideosListViewController

#pragma mark -
#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:_tableView.frame toView:self.view];   
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[self videos] count] == 0) {
        [self loadVideos];
        [self.activityIndicator startAnimating];
    }
    
}

- (void)dealloc
{
    [self setSection:nil];
    [self setTableView:nil];
    [self setVideos:nil];
    [_activityIndicator release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSection:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark load videos

- (void) loadVideos
{
    [[RequestHelper sharedInstance] loadVideosWithDelegate:self];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    [UIAlertView showConnectionProblemMessage];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self setVideos:objects];
    [[self tableView] reloadData];
    [[self activityIndicator] stopAnimating];
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self videos] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"videosCell";
    ImageCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier] autorelease];
    }
    
    Video *video = [[self videos] objectAtIndex:indexPath.row];
    cell.nameLabel.text = video.name;
    [cell.thumbImageView setImageWithURL:[video youtubeThumbURL]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:NO];

    Video *video = [[self videos] objectAtIndex:indexPath.row];
    NSString *trackedViewName = [[self trackedViewName] stringByAppendingFormat:@" : %@", [video name]];
    
    VideoViewController *controller = [[VideoViewController new] autorelease];
    controller.videoUrl = video.url;
    controller.trackedViewName = trackedViewName;

    [self.navigationController pushViewController:controller animated:YES];
}

@end
