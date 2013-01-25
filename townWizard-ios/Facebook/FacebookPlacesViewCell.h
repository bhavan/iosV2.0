//
//  FacebookPlacesViewCell.h
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "SDWebImageDownloader.h"
@class Place;
@class ActivityImageView;

typedef enum {
    FBPC_LOAD_NONE,
    FBPC_LOAD_PAGE,
    FBPC_LOAD_IMAGE,
    FBPC_LOAD_CHECKINS,
    FBPC_LOAD_DONE,
} FBPlacesCellLoadStage;

@interface FacebookPlacesViewCell : UITableViewCell <FBRequestDelegate, SDWebImageDownloaderDelegate> {
	UILabel *nameLabel;
	UILabel *categoryLabel;
	UILabel *addressLabel;
    
    UILabel *checkinsTotalLabel;
    UIActivityIndicatorView *checkinsTotalActivity;
    UILabel *checkinsFriendsLabel;
    UIActivityIndicatorView *checkinsFriendsActivity;
    ActivityImageView *imageView;

    
    Place *place;
    Facebook *facebook;
    FBPlacesCellLoadStage loadStage;
}

@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic,retain) IBOutlet UILabel *addressLabel;

@property (nonatomic,retain) IBOutlet UILabel *checkinsTotalLabel;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *checkinsTotalActivity;
@property (nonatomic,retain) IBOutlet UILabel *checkinsFriendsLabel;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *checkinsFriendsActivity;
@property (nonatomic,retain) IBOutlet ActivityImageView *imageView;


@property (nonatomic,retain) Place *place;
@property (nonatomic,copy) NSString *pageId;
@property (nonatomic,retain) Facebook *facebook;

- (void) loadPlace:(Place *)place withFacebook:(Facebook *)facebook extended:(BOOL)extended;

@end
