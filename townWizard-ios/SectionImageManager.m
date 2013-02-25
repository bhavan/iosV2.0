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
    if (self = [super init])
    {
        images = [@{
        @"photos" : @"profile",
        @"weather" : @"weather",
        @"news feed" : @"news",
       // @"news" : @"news",
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
        @"advertise with us" : @"advertise",
        @"contact us" : @"contacts"
        } retain];
        
        containImages = [@{@"video" : @"icon_video",
                          @"about" : @"icon_question",
                          @"facebook" : @"icon_facebook",
                          @"home" : @"icon_home",
                          @"google +" : @"icon_googlePlus",
                          @"places" : @"icon_places",
                          @"shopping" : @"icon_shopping",
                          @"twitter" : @"icon_twitter",} retain];

    }
    return self;
}

- (UIImage *) imageForSection:(Section *) section
{
    NSString *imageName = [images objectForKey:[[section displayName] lowercaseString]];
   /* if(!imageName)
    {
       imageName = [images objectForKey:[[section displayName] lowercaseString]];
    }*/
    if(!imageName)
    {
        for (NSString *key in [containImages allKeys])
        {
            NSRange range = [section.displayName rangeOfString:key options:NSCaseInsensitiveSearch];
            if(range.length == key.length)
            {
                imageName = [containImages objectForKey:key];
            }
        }
        
    }
    return [UIImage imageNamed:imageName];
}


- (void)dealloc
{
    [containImages release];
    [images release];
    [super dealloc];
}



@end
