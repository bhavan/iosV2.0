//
//  Place.h
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"

@interface Place : NSObject<SDWebImageDownloaderDelegate> {
	NSString *name;
	NSString *category;
	NSString *address;
	NSString *place_id;
	double latitude;
	double longitude;
    
    NSNumber *totalCheckins;
    NSNumber *friendsCheckins;
    UIImage *image;
}

// Basic info from search query
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *place_id;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

// Extended info
@property (nonatomic,copy) NSNumber *totalCheckins;
@property (nonatomic,copy) NSNumber *friendsCheckins;
@property (nonatomic,retain) UIImage *image;
@end
