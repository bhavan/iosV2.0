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
        
        NSDictionary *predefinedImages = [self predefinedImages];
        for (NSString *sectionName in [predefinedImages allKeys]) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[predefinedImages objectForKey:sectionName]
                                                                  ofType:@"png"];
            [images setObject:imagePath forKey:sectionName];
        }
    }
    return self;
}

- (UIImage *) imageForSection:(Section *) section
{
    NSString *imagePath = [images objectForKey:[section name]];
    if (imagePath) {
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        return [UIImage imageWithData:imageData];
    }
    
    return [images objectForKey:[section name]];
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
