//
//  PhotoGalleryViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "PhotoGalleryViewController.h"
#import "Photo.h"
#import "WebImageGridViewCell.h"
#import "UIImageView+WebCache.h"
#import "TownWIzardNavigationBar.h"

@interface PhotoGalleryViewController ()

@end

@implementation PhotoGalleryViewController

@synthesize gridView;

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

#pragma mark --
#pragma mark RKObjectLoader delegate methods
- (void)objectLoader:(RKObjectLoader *)objectLoader willMapData:(inout id *)mappableData
{   
    Class class = [objectLoader.targetObject class];    
    NSLog(@"%@",[class description]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if([[objects lastObject] isKindOfClass:[Photo class]]){
         photos = [[NSArray alloc] initWithArray:objects];
        loadedImages = [[NSMutableArray alloc] initWithCapacity:photos.count];
        [gridView setNeedsLayout];
        [gridView reloadData];
    }
}

#pragma mark --
#pragma mark AQGridViewDelegate delegate/datasource methods

- (NSUInteger)numberOfItemsInGridView: (AQGridView *) gridView
{
    if (photos)
    {
        return [photos count];
    }
    return 0;
}


- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return CGSizeMake(100, 100);
}

- (AQGridViewCell *)gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *cellIdentifier = @"gridCell";
    WebImageGridViewCell *cell = (WebImageGridViewCell *)[aGridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[[WebImageGridViewCell alloc]initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      100,
                                                                      100)
                                           reuseIdentifier:cellIdentifier] autorelease];
        [cell initializeCell];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        
    }
    Photo *photo = [photos objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:photo.thumb];
  
    [cell.imageView setImageWithURL:url
                   placeholderImage:nil
                            options:SDWebImageCacheMemoryOnly];
    return cell;
}


- (void)gridView:(AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    currentIndex = index;
    MWPhotoBrowser *browser = [[[MWPhotoBrowser alloc] initWithDelegate:self] autorelease];
    browser.wantsFullScreenLayout = NO;
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:index];

    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navController animated:YES];
    [navController release];
    //[browser setInitialPageIndex:1];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return photos.count;
 
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if(index < photos.count)
    {
        Photo *twThoto = [photos objectAtIndex:0];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:twThoto.picture]];
        photo.caption = twThoto.name;        
        return photo;
    }
   
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [gridView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setGridView:nil];
    [super viewDidUnload];
}
@end
