//
//  PhotoCategoriesViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "PhotoCategoriesViewController.h"
#import "RequestHelper.h"
#import "Photo.h"
#import "PhotoCategory.h"
#import "PhotoGalleryViewController.h"
#import "TownWIzardNavigationBar.h"
#import "ImageCell.h"
#import "UIImageView+WebCache.h"
#import "PhotoUploadView.h"

@interface PhotoCategoriesViewController ()

@end

@implementation PhotoCategoriesViewController

@synthesize categories, section;

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
    self.customNavigationBar.subMenuLabel.text = @"Photos";
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
        categories = [[NSArray alloc] initWithArray:objects];
        [self.tableView reloadData];
        
    }
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(categories) {
        return [categories count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"categoryCell";
    ImageCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PhotoCategory *category = [categories objectAtIndex:indexPath.row];
    if(cell == nil)
    {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.nameLabel.text = category.name;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:category.thumb]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCategory *category = [categories objectAtIndex:indexPath.row];
    PhotoGalleryViewController *galleryController = [PhotoGalleryViewController new];
    galleryController.customNavigationBar = self.customNavigationBar;
    galleryController.partner = self.partner;
    [RequestHelper photosWithPartner:partner section:section fromCategory:category andDelegate:galleryController];
    [self.navigationController pushViewController:galleryController animated:YES];
    [galleryController release];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
