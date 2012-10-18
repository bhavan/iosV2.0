//
//  FacebookPlacesViewCell.m
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookPlacesViewCell.h"
#import "Place.h"
#import "JSONKit.h"

@interface FacebookPlacesViewCell()
- (void) loadAdditionalInfo;
- (void) loadImageFrom:(NSString *)urlString;
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
@synthesize imageActivity;
@synthesize pageId;
@synthesize facebook;
@synthesize place;

#pragma mark -

- (void) loadPlace:(Place *)aPlace withFacebook:(Facebook *)aFacebook extended:(BOOL)extended {    
    self.place = aPlace;
    
	[self.nameLabel setText:place.name];
	[self.categoryLabel setText:place.category];
	[self.addressLabel setText:place.address];
    
    self.facebook = aFacebook;

    if (extended)
        [self loadAdditionalInfo];
}

#pragma mark - Private methods

- (void) updateExtendedInfo {
    if (!place.totalCheckins) {
        if (![checkinsTotalActivity isAnimating])
            [checkinsTotalActivity startAnimating];
        checkinsTotalLabel.hidden = YES;
    }
    else {
        if ([checkinsTotalActivity isAnimating])
            [checkinsTotalActivity stopAnimating];
        checkinsTotalLabel.hidden = NO;
        checkinsTotalLabel.text = [NSString stringWithFormat:@"%@ total", place.totalCheckins];
    }
    
    if (!place.friendsCheckins) {
        if (![checkinsFriendsActivity isAnimating])
            [checkinsFriendsActivity startAnimating];
        checkinsFriendsLabel.hidden = YES;
    }
    else {
        if ([checkinsFriendsActivity isAnimating]) 
            [checkinsFriendsActivity stopAnimating];
        checkinsFriendsLabel.hidden = NO;
        checkinsFriendsLabel.text = [NSString stringWithFormat:
                                     @"%@ by friends", place.friendsCheckins];
        
    }
    
    if (!place.image) {
        if (![imageActivity isAnimating]) 
            [imageActivity startAnimating];
        imageView.hidden = YES;
    }
    else {
        if ([imageActivity isAnimating])
            [imageActivity stopAnimating];
        imageView.hidden = NO;
        imageView.image = place.image;
    }
}

- (void) loadNextStage {

    FBPlacesCellLoadStage nextStage;
    switch (loadStage) {
        case FBPC_LOAD_NONE:
            if (!place.totalCheckins || !place.image) {
                nextStage = FBPC_LOAD_PAGE;
                break;
            }
        case FBPC_LOAD_IMAGE:
            if (!place.friendsCheckins) {
                nextStage = FBPC_LOAD_CHECKINS;
                break;
            }
        case FBPC_LOAD_CHECKINS:
            nextStage = FBPC_LOAD_DONE;
        default:
            nextStage = FBPC_LOAD_NONE;
            break;
    }
    
    loadStage = nextStage;
    switch (loadStage) {
        case FBPC_LOAD_PAGE:
            [facebook requestWithGraphPath:place.place_id andDelegate:self];  
            break;
        case FBPC_LOAD_CHECKINS:
            [self loadCheckins];
            break;
        default:
            break;
    }
}

- (void) loadAdditionalInfo {
    [self updateExtendedInfo];

    // next stage
    loadStage = FBPC_LOAD_NONE;
    [self loadNextStage];
}

- (void) loadImageFrom:(NSString *)urlString {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    loadStage = FBPC_LOAD_IMAGE;
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    place.image = [UIImage imageWithData:imageData];
    [imageData release];
    
    [self performSelectorOnMainThread:@selector(updateExtendedInfo) withObject:nil waitUntilDone:NO];
    
    // next stage
    [self performSelectorOnMainThread:@selector(loadNextStage) withObject:nil waitUntilDone:NO];
    
    [pool drain];
}

- (void) loadCheckins {
    loadStage = FBPC_LOAD_CHECKINS;
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/checkins", place.place_id] 
                       andDelegate:self];
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSString *resultJson = [[NSString alloc] initWithData:request.responseText encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [resultJson objectFromJSONString];
    [resultJson release];
    switch (loadStage) {
        case FBPC_LOAD_PAGE:
            place.totalCheckins = [jsonDict objectForKey:@"checkins"] ? 
                [jsonDict objectForKey:@"checkins"] : [NSNumber numberWithInt:0];
            [self updateExtendedInfo];
            
            // next stage
            if (!place.image) {
                [self performSelectorInBackground:@selector(loadImageFrom:) 
                                       withObject:[jsonDict objectForKey:@"picture"]];
            }
            break;
        case FBPC_LOAD_CHECKINS:
            place.friendsCheckins = [NSNumber numberWithInt:[[jsonDict objectForKey:@"data"] count]];
            [self updateExtendedInfo];
            
            loadStage = FBPC_LOAD_DONE;
            break;
        default:
            break;
    }
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
    self.imageActivity = nil;
    self.pageId = nil;
    self.facebook = nil;
    self.place = nil;
    [super dealloc];
}

@end
