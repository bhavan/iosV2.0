//
//  VideosViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "VideosViewController.h"
#import "TownWIzardNavigationBar.h"
#import "ImageCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"

@interface VideosViewController ()

@end

@implementation VideosViewController

@synthesize  partner, customNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.customNavigationBar.menuButton addTarget:self
                                            action:@selector(menuButtonPressed)
                                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customNavigationBar.menuButton removeTarget:self
                                               action:@selector(menuButtonPressed)
                                     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)menuButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout id *)mappableData
{
    
}



- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (objects)
    {
        videos = [[NSArray alloc] initWithArray:objects];
        [self.tableView reloadData];
        
    }
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(videos) {
        return [videos count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"videosCell";
    ImageCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Video *video = [videos objectAtIndex:indexPath.row];
    if(cell == nil)
    {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.nameLabel.text = video.name;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:video.thumb]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*  PhotoCategory *category = [categories objectAtIndex:indexPath.row];
    PhotoGalleryViewController *galleryController = [PhotoGalleryViewController new];
    galleryController.customNavigationBar = self.customNavigationBar;
    [RequestHelper photosWithPartner:partner fromCategory:category andDelegate:galleryController];
    [self.navigationController pushViewController:galleryController animated:YES];
    [galleryController release];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
