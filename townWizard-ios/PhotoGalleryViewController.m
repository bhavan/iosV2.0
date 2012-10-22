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

@interface PhotoGalleryViewController () <RKObjectLoaderDelegate>
@property (nonatomic, retain) NSArray *photos;
@end

@implementation PhotoGalleryViewController

#pragma mark -
#pragma mark life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    [[RequestHelper sharedInstance] loadPhotosFromCategory:[self category] delegate:self];
}

- (void)dealloc {
    [self setGridView:nil];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setGridView:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //display alert
    NSLog(@"%@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self setPhotos:objects];
//??    [gridView setNeedsLayout];
    [gridView reloadData];
}

#pragma mark -
#pragma mark AQGridViewDelegate delegate/datasource methods

- (NSUInteger)numberOfItemsInGridView: (AQGridView *) gridView
{
    return [[self photos] count];
}


- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return CGSizeMake(100, 100);
}

- (AQGridViewCell *)gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *cellIdentifier = @"gridCell";
    WebImageGridViewCell *cell = (WebImageGridViewCell *)[aGridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        
//        cell = [[[WebImageGridViewCell alloc]initWithFrame:CGRectMake(0,
//                                                                      0,
//                                                                      100,
//                                                                      100)
//                                           reuseIdentifier:cellIdentifier] autorelease];
        cell = [[WebImageGridViewCell alloc] init];
        [cell setRestorationIdentifier:cellIdentifier];

//        [cell initializeCell];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        
    }
    Photo *photo = [[self photos] objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:photo.thumb];
  
    [cell.imageView setImageWithURL:url
                   placeholderImage:nil
                            options:SDWebImageCacheMemoryOnly];
    return cell;
}


- (void)gridView:(AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
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
    return [[self photos] count];
 
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if(index < [self photos].count)
    {
        Photo *twThoto = [[self photos] objectAtIndex:index];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:twThoto.picture]];
        photo.caption = twThoto.name;        
        return photo;
    }
   
    return nil;
}

@end
