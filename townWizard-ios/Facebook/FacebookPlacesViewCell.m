//
//  FacebookPlacesViewCell.m
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookPlacesViewCell.h"
#import "Place.h"
#import "ActivityImageView.h"

@interface FacebookPlacesViewCell()

- (void) loadCheckins;
@end

@implementation FacebookPlacesViewCell

@synthesize nameLabel;
@synthesize categoryLabel;
@synthesize addressLabel;
@synthesize checkinsTotalLabel;
@synthesize checkinsTotalActivity;
@synthesize checkinsFriendsLabel;
@synthesize checkinsFriendsActivity;
@synthesize imageView;
@synthesize pageId;
@synthesize facebook;
@synthesize place;

#pragma mark -

- (void) loadPlace:(Place *)aPlace withFacebook:(Facebook *)aFacebook extended:(BOOL)extended
{
    self.place = aPlace;
    [imageView setImageWithURL:[NSURL URLWithString:[place.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[self.nameLabel setText:place.name];
	[self.categoryLabel setText:place.category];
	[self.addressLabel setText:place.address];
    checkinsTotalLabel.hidden = NO;
    checkinsFriendsLabel.hidden = NO;
    if(!place.totalCheckins)
    {
        place.totalCheckins = [NSNumber numberWithInt:0];
    }    
    
    checkinsTotalLabel.text = [NSString stringWithFormat:@"%@ total", place.totalCheckins];
    self.facebook = aFacebook;
    
    if (extended)
        [self loadCheckins];
}

#pragma mark - Private methods

- (void) updateExtendedInfo
{
    if (!place.friendsCheckins)
    {
        if (![checkinsFriendsActivity isAnimating])
            [checkinsFriendsActivity startAnimating];
       // checkinsFriendsLabel.hidden = YES;
    }
    else
    {
        if ([checkinsFriendsActivity isAnimating])
            [checkinsFriendsActivity stopAnimating];
        checkinsFriendsLabel.hidden = NO;
        checkinsFriendsLabel.text = [NSString stringWithFormat:
                                     @"%@ by friends", place.friendsCheckins];        
    }
}


- (void) loadCheckins
{
    if(!place.friendsCheckins)
    {
    loadStage = FBPC_LOAD_CHECKINS;
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/checkins", place.place_id]
                       andDelegate:self];
    }
    else
    {
        checkinsFriendsLabel.text = [NSString stringWithFormat:
                                     @"%@ by friends", place.friendsCheckins];
    }
    
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:request.responseText options:NSJSONReadingAllowFragments error:nil];
    place.friendsCheckins = [NSNumber numberWithInt:[[jsonDict objectForKey:@"data"] count]];
    [self updateExtendedInfo];
    
}

#pragma mark - Memory management

- (void) dealloc {
    self.nameLabel = nil;
    self.categoryLabel = nil;
    self.addressLabel = nil;
    self.checkinsTotalLabel = nil;
    self.checkinsTotalActivity = nil;
    self.checkinsFriendsLabel = nil;
    self.checkinsFriendsActivity = nil;
    self.imageView = nil;
    self.pageId = nil;
    self.facebook = nil;
    self.place = nil;
    [super dealloc];
}

@end
