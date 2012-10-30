//
//  SectionImageManager.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import "SectionImageManager.h"
#import "Section.h"

static SectionImageManager *sectionImageManager = nil;

@implementation SectionImageManager

+ (id) sharedInstance
{
    @synchronized (self) {
        if (sectionImageManager == nil) {
            sectionImageManager = [[self alloc] init];
        }
    }
    return sectionImageManager;
}

- (id) init
{
    if (self = [super init]) {
        images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (UIImage *) imageForSection:(Section *) section
{
    NSString *imageName = [[self predefinedImages] objectForKey:[section name]];
    return [UIImage imageNamed:imageName];
}

- (NSDictionary *) predefinedImages
{
    return @{
        @"News Feed" : @"news",
        @"Events" : @"events",
        @"Offers" : @"offer",
        @"Nightlife" : @"nightlife",
        @"Entertainment" : @"entertainment",
        @"Town Dirrectory" : @"towndirrectory",
        @"Your Profile" : @"profile",
        @"Your Saved Items" : @"saved",
        @"Settings & Preferences" : @"settings",
        @"Best in Town Lists" : @"bestintown",
        @"Talk of the Town Blog" : @"talk",
        @"Ratings & Reviews" : @"ratings",
        @"Check-ins & Hotspots" : @"checkins",
        @"Help & Support" : @"help",
        @"About TownWizard" : @"about",
        @"Advertise with TownWizard" : @"advertise",
        @"Contact TownWizard" : @"contacts"
    };
}

@end
