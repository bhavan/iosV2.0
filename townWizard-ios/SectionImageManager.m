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
        if (sectionImageManager == nil)
        {
            sectionImageManager = [[self alloc] init];
        }
    }
    return sectionImageManager;
}

- (id) init
{
    if (self = [super init]) {
        images = [@{
        @"videos" : @"video",
        @"photos" : @"profile",
        @"weather" : @"weather",
        @"news feed" : @"news",
        @"news" : @"news",
        @"places" : @"towndirrectory",
        @"restaurants" : @"restaurants",
        @"events" : @"events",
        @"offers" : @"offer",
        @"nightlife" : @"nightlife",
        @"entertainment" : @"entertainment",
        @"town dirrectory" : @"towndirrectory",
        @"your profile" : @"profile",
        @"your saved items" : @"saved",
        @"settings & preferences" : @"settings",
        @"best in town lists" : @"bestintown",
        @"talk of the town blog" : @"talk",
        @"ratings & reviews" : @"ratings",
        @"check-ins & hotspots" : @"checkins",
        @"help & support" : @"help",
        @"about us" : @"about",
        @"advertise with us" : @"advertise",
        @"contact us" : @"contacts"
        } retain];
;
    }
    return self;
}

- (UIImage *) imageForSection:(Section *) section
{
    NSString *imageName = [images objectForKey:[[section name] lowercaseString]];
    if(!imageName)
    {
       imageName = [images objectForKey:[[section displayName] lowercaseString]];
    }
    return [UIImage imageNamed:imageName];
}


- (void)dealloc
{
    [images release];
    [super dealloc];
}



@end
