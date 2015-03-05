//
//  FacebookCheckinViewController.m
//  GenericApp
//
//  Created by John Doe on 6/16/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookCheckinViewController.h"
#import "FacebookFriend.h"
#import "FacebookFriendCell.h"
#import "FacebookHelper.h"
#import "AppDelegate.h"

#define IMAGE_RECT CGRectMake(2,2,40,40)

@implementation FacebookCheckinViewController

@synthesize messageView;
@synthesize friendsListView;
@synthesize place;
@synthesize friends;
@synthesize filteredFriends;
@synthesize searchView;

- (id) initWithSelectedPlace:(Place *)aPlace
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.place = aPlace;
        taggedFriends = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [searchView setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [messageView setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //self.navigationItem.hidesBackButton = YES;
    
    //[self.friendsListView.layer setCornerRadius:10];
    [friendsListView setBackgroundColor:[UIColor clearColor]];
    [friendsListView setSeparatorColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.]];
    
    checkInProgress = NO;
    
    self.friendsListView.accessibilityLabel = @"Friend list";
}


- (void)menuButtonPressed {
    if (!checkInProgress)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.customNavigationBar.menuButton addTarget:self 
//                                            action:@selector(menuButtonPressed) 
//                                  forControlEvents:UIControlEventTouchUpInside];
    
    FacebookHelper *facebookHelper = [AppDelegate sharedDelegate].facebookHelper;
    self.friends = nil;
    self.filteredFriends = nil;
    [facebookHelper.facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.customNavigationBar.menuButton removeTarget:self 
//                                               action:@selector(menuButtonPressed) 
//                                     forControlEvents:UIControlEventTouchUpInside];
    [super viewWillDisappear:animated];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchView resignFirstResponder];
    [self.messageView resignFirstResponder];
}

-(IBAction)dismissKeyboardByPressingRandomSpaceOnScreen:(id)sender
{
    [self.searchView resignFirstResponder];
    [self.messageView resignFirstResponder];
}

#pragma mark -

- (void) updateSearchResults {
    NSString *searchString = searchView.text;
    if ([searchString length]) {
        NSMutableArray *filtered = [NSMutableArray array];
        for (FacebookFriend *friend in friends) {
            if ([friend.name rangeOfString:searchString 
                                   options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [filtered addObject:friend];
            }
        }
        self.filteredFriends = filtered;
    }
    else {
        self.filteredFriends = friends;
    }
    [self.friendsListView reloadData];
}

#pragma mark - Actions

- (IBAction) performCheckin {   
    
    [[UIApplication sharedApplication] showNetworkActivityIndicator];

    if (checkInProgress) return;
    
    checkInProgress = YES;
    
    FacebookHelper *facebookHelper = [AppDelegate sharedDelegate].facebookHelper;
       
    NSString *center = [NSString stringWithFormat:
                        @"{\"latitude\":\"%f\",\"longitude\":\"%f\"}", 
                        [AppDelegate sharedDelegate].doubleLatitude,
                        [AppDelegate sharedDelegate].doubleLongitude
                        //place.latitude, place.longitude// FOR DEBUGGING PURPOSES ONLY
                        ];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [facebookHelper.facebook accessToken], @"access_token",
                                   place.place_id, @"place",
                                   center, @"coordinates",
                                   nil];
    
    if ([self.messageView.text length])
        [params setValue:self.messageView.text forKey:@"message"];
    
    if ([taggedFriends count]) {
        NSMutableString *tagsString = [[NSMutableString alloc] init];
        BOOL first = YES;
        for (FacebookFriend *friend in taggedFriends) {
            if (!first) {
                [tagsString appendString:@", "];
            }
            first = NO;
            
            [tagsString appendString:friend.facebookId];
        }
        
        [params setValue:tagsString forKey:@"tags"];
        [tagsString release];
    }
    [facebookHelper.facebook requestWithGraphPath:@"me/checkins" 
                                        andParams:params 
                                    andHttpMethod:@"POST"
                                      andDelegate:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == searchView) {
        [self updateSearchResults];
    }
    return NO;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self updateSearchResults];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - FBRequestDelegate

- (void) request:(FBRequest *)request didLoad:(id)result {
    if ([request.url hasSuffix:@"me/friends"]) {
        [taggedFriends removeAllObjects];
        NSMutableArray *friendsList = [NSMutableArray array];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:request.responseText options:0 error:nil];
        for (NSDictionary *friendInfo in [jsonDict objectForKey:@"data"])
        {
            
            FacebookFriend * fbFriend = [[FacebookFriend alloc] initWithInfo:friendInfo];
            [friendsList addObject:fbFriend];
            [fbFriend release];
        }
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [friendsList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        [descriptor release];
        self.friends = friendsList;
        [self updateSearchResults];
        
        [self.friendsListView reloadData];
    }
    else if ([request.url hasSuffix:@"me/checkins"])
    {
        
        [[[[UIAlertView alloc] initWithTitle:@"CHECK IN"
                                     message:@"You've successfully checked in"
                                    delegate:nil
                           cancelButtonTitle:@"Continue" 
                           otherButtonTitles:nil] autorelease] show];

        checkInProgress = NO;
        
        NSArray * viewControllersInNavigationStack = self.navigationController.viewControllers;
        
        id subMenuVC = [viewControllersInNavigationStack
                        objectAtIndex:[viewControllersInNavigationStack count]-3];
        [self.navigationController popToViewController:subMenuVC animated:YES];
    }
    
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
}

- (void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSDictionary *errorInfo = [[error userInfo] objectForKey:@"error"];
    [[[[UIAlertView alloc] initWithTitle:@"Error"
                                 message:[errorInfo objectForKey:@"message"]
                                delegate:nil
                       cancelButtonTitle:@"Continue" 
                       otherButtonTitles:nil] autorelease] show];

    checkInProgress = NO;
    [[UIApplication sharedApplication] hideNetworkActivityIndicator];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (friends) {
        FacebookFriendCell* cell = (FacebookFriendCell*)[tableView dequeueReusableCellWithIdentifier:@"FacebookFriendCell"];
        if (!cell) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FacebookFriendCell" 
                                                                     owner:nil 
                                                                   options:nil];
            for (id currentObject in topLevelObjects) {
                if([currentObject isKindOfClass:[FacebookFriendCell class]])     {
                    cell = (FacebookFriendCell*)currentObject;
                    break;
                }           
            }
        }       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FacebookFriend *friend = [filteredFriends objectAtIndex:indexPath.row];
        [cell setFriend:friend];
        
        cell.accessoryView.hidden = ![taggedFriends containsObject:friend];

        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"Loading"] autorelease];
            cell.detailTextLabel.text = @"Loading..";
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return friends ? [filteredFriends count] : 1;
}

- (NSIndexPath *) tableView:(UITableView *)tableView 
   willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacebookFriend* friend = [filteredFriends objectAtIndex:indexPath.row];
    if (![taggedFriends containsObject:friend])
        [taggedFriends addObject:friend];
    else
        [taggedFriends removeObject:friend];
    
    //[self.friendsListView reloadData];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                     withRowAnimation:UITableViewRowAnimationNone];
    return nil;
}

#pragma mark - Memory management

-(void)cleanUp {
    
//    [self.customNavigationBar.menuButton removeTarget:self 
//                                               action:@selector(menuButtonPressed) 
//                                     forControlEvents:UIControlEventTouchUpInside];
    self.messageView = nil;
    self.friendsListView = nil;

    self.searchView = nil;
    self.place = nil;
    self.friends = nil;
    [filteredFriends release];
    [taggedFriends release];
    
}

- (void) viewDidUnload {
    [self cleanUp];
    [super viewDidUnload];
}

- (void) dealloc {
    [self cleanUp];
    [super dealloc];
}

@end
