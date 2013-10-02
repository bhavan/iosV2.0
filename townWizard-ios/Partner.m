//
//  Partner.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import "Partner.h"

@implementation Partner

- (void)dealloc
{
    [_partnterId release];
    [_name release];
    [_iTunesAppId release];
    [_facebookAppId release];
    [_headerImageUrl release];
    [_webSiteUrl release];
    [_locations release];

    [super dealloc];
}

@end
