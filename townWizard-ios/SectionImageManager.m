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
                  @"news" : @"news",
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
                  @"contact us" : @"contacts",
                  // bhavan: from containImages
                  @"videos" : @"icon_video",
                  @"about us" : @"icon_question",  // use "?" icon; used for about App/Partner
                  @"about" : @"icon_question",     // use "?" icon; used for About Town
                  @"facebook" : @"icon_facebook",
                  @"home" : @"icon_home",
                  @"google +" : @"icon_googlePlus",
                  @"places" : @"icon_places",
                  @"shopping" : @"icon_shopping",
                  @"twitter" : @"icon_twitter"
                  } retain];
        
        // bhavan: containImages is also a dictionally. Separate variable is not required
        //   adding these key/value pairs in the image dictionaly object.
        //containImages = [@{@"video" : @"icon_video",
        //                  @"about" : @"icon_question",
        //                  @"facebook" : @"icon_facebook",
        //                  @"home" : @"icon_home",
        //                  @"google +" : @"icon_googlePlus",
        //                  @"places" : @"icon_places",
        //                  @"shopping" : @"icon_shopping",
        //                  @"twitter" : @"icon_twitter",} retain];

    }
    return self;
}

- (UIImage *) imageForSection:(Section *) section
{
    NSString *imageName = [images objectForKey:[[section displayName] lowercaseString]];
   
    if (!imageName)
    {
        // did not find image name based on display name; see if we can find using section name
        imageName = [images objectForKey:[[section name] lowercaseString]];
    }
    
    // bhavan: if it is still nil, it is ok. calling function will use default "star" image
    
    // bhavan: no need for this block as key/value pairs are moved in to the "image" dictionanry
    //if(!imageName)
    //{
    //    for (NSString *key in [containImages allKeys])
    //    {
    //        NSRange range = [section.displayName rangeOfString:key options:NSCaseInsensitiveSearch];
    //        if(range.length == key.length)
    //        {
    //            imageName = [containImages objectForKey:key];
    //        }
    //    }
    //}
    
    return [UIImage imageNamed:imageName];
}


- (void)dealloc
{
    // bhavan: containImages no longer used
    // [containImages release];
    [images release];
    [super dealloc];
}



@end
