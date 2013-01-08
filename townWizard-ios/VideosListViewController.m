//
//  VideosViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "VideosListViewController.h"
#import "TownWIzardNavigationBar.h"
#import "ImageCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "SubMenuViewController.h"
#import "Partner.h"
#import "Section.h"
#import "VideoViewController.h"
#import "TWBackgroundView.h"

#import "RequestHelper.h"

#import <MediaPlayer/MediaPlayer.h>

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
    TWBackgroundView *backgroundView = [[TWBackgroundView alloc] initWithFrame:_tableView.frame];
    [self.view insertSubview:backgroundView atIndex:0];
    [backgroundView release];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadVideos];
}

- (void)dealloc
{
    [self setSection:nil];
    [self setTableView:nil];
    [self setVideos:nil];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSection:nil];
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
    NSLog(@"ololo %@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self setVideos:objects];
    [[self tableView] reloadData];
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
    if(cell == nil) {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier] autorelease];
    }
    
    Video *video = [[self videos] objectAtIndex:indexPath.row];

    cell.nameLabel.text = video.name;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:video.thumb]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:NO];

    Video *video = [[self videos] objectAtIndex:indexPath.row];
    VideoViewController *subMenu = [[VideoViewController new] autorelease];
    subMenu.videoUrl = video.url;    
    [self.navigationController pushViewController:subMenu animated:YES];
    
//    NSURL *videoURL = [NSURL URLWithString:[video url]];
//    MPMoviePlayerController *controller = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//    [[controller view] setFrame:[[self view] bounds]];
//    [[self view] addSubview:[controller view]];
//    [controller play];
//    [controller release];
}

@end
