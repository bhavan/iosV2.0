//
//  Place.m
//  GenericApp
//
//  Created by Alexey Denisov on 3/12/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "Place.h"
#import "DataHolder.h"

@implementation Place

- (void) dealloc {
    self.name = nil;
    self.category = nil;
    self.address = nil;
    self.place_id = nil;
    self.totalCheckins = nil;
    self.friendsCheckins = nil;
    self.image = nil;
    self.imageUrl = nil;
    [super dealloc];
}

#pragma mark -

@synthesize name;
@synthesize category;
@synthesize address;
@synthesize place_id;
@synthesize latitude;
@synthesize longitude;
@synthesize totalCheckins;
@synthesize friendsCheckins;
@synthesize image;


@end
