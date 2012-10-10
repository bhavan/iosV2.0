//
//  Partner.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import "Partner.h"

@implementation Partner

@synthesize partnterId, name, iTunesAppId, facebookAppId, headerImageUrl, webSiteUrl;

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[Partner class]];
    [partnersMapping mapKeyPath:@"id" toAttribute:@"partnterId"];
    [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"itunes_app_id" toAttribute:@"iTunesAppId"];
    [partnersMapping mapKeyPath:@"facebook_app_id" toAttribute:@"facebookAppId"];
    [partnersMapping mapKeyPath:@"image" toAttribute:@"headerImageUrl"];
     [partnersMapping mapKeyPath:@"website_url" toAttribute:@"webSiteUrl"];
    return partnersMapping;

}

@end
