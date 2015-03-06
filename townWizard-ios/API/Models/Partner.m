//
//  Partner.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import "Partner.h"
#import "Location.h"

@implementation Partner

- (void)dealloc
{
    [_partnerId release];
    [_name release];
    [_iTunesAppId release];
    [_facebookAppId release];
    [_headerImageUrl release];
    [_webSiteUrl release];
    [_locations release];

    [super dealloc];
}

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:self];
    [mapping mapPropertiesFromDictionary:@{
                                           @"id":@"partnerId",
                                           @"name":@"name",
                                           @"itunes_app_id":@"iTunesAppId",
                                           @"facebook_app_id":@"facebookAppId",
                                           @"image":@"headerImageUrl",
                                           @"website_url":@"webSiteUrl"
                                           }];
    [mapping hasOne:[Location class] forKeyPath:@"locations"];
    return [mapping autorelease];
}

@end
