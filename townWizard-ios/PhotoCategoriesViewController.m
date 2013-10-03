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
#import "ImageCell.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+Extensions.h"
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
    [[AppActionsHelper sharedInstance] putTWBackgroundWithFrame:_tableView.frame
                                                         toView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    if ([[self categories] count] == 0) {
        [[RequestHelper sharedInstance] loadPhotoCategoriesWithDelegate:self];
        [[self activityIndicator] startAnimating];
    }
}

- (void)dealloc
{
    [self setTableView:nil];   
    [self setCategories:nil];
    [_activityIndicator release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setActivityIndicator:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [UIAlertView showConnectionProblemMessage];
    [[self activityIndicator] stopAnimating];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[self activityIndicator] stopAnimating];
    [self setCategories:objects];
    [[self tableView] reloadData];
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self categories] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"categoryCell";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];    
    if(cell == nil)
    {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier] autorelease];
    }    
    PhotoCategory *category = [[self categories] objectAtIndex:indexPath.row];
    cell.nameLabel.text = category.name;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:[category.thumb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PhotoCategory *category = [[self categories] objectAtIndex:indexPath.row];
    NSString *trackedViewName = [[self trackedViewName] stringByAppendingFormat:@" : %@", [category name]];
    
    PhotoGalleryViewController *controller = [[PhotoGalleryViewController new] autorelease];
    [controller setCategory:category];
    [controller setTrackedViewName:trackedViewName];
    
    [[self navigationController] pushViewController:controller animated:YES];
}

@end
