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
#import "TWBackgroundView.h"

@interface PhotoCategoriesViewController ()
@property (nonatomic, retain, readwrite) NSArray *categories;
@end

@implementation PhotoCategoriesViewController

#pragma mark -
#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    TWBackgroundView *backgroundView = [[TWBackgroundView alloc] initWithFrame:_tableView.frame];
    [self.view insertSubview:backgroundView atIndex:0];
    [backgroundView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    [[RequestHelper sharedInstance] loadPhotoCategoriesWithDelegate:self];
}

- (void)dealloc {
    [self setTableView:nil];   
    [self setCategories:nil];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self setCategories:objects];
    [[self tableView] reloadData];
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self categories] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"categoryCell";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier] autorelease];
    }
    
    PhotoCategory *category = [[self categories] objectAtIndex:indexPath.row];
    cell.nameLabel.text = category.name;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:category.thumb]];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PhotoGalleryViewController *controller = [[PhotoGalleryViewController new] autorelease];
    [controller setCategory:[[self categories] objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:controller animated:YES];
}

@end
