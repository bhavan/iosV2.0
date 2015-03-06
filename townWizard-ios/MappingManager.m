//
//  MappingManager.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "MappingManager.h"

#import "Event.h"
#import "Location.h"
#import "Partner.h"
#import "Section.h"
#import "EventCategory.h"
#import "PhotoCategory.h"
#import "Photo.h"
#import "Video.h"

static MappingManager *mappingManager = nil;

@implementation MappingManager

+ (id) sharedInstance
{
    @synchronized (self)
    {
        if (mappingManager == nil)
        {
            mappingManager = [[self alloc] init];
        }
    }
    return mappingManager;
}

- (RKObjectMapping *)photoMapping
{
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[Photo class]];
    
    [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"thumb" toAttribute:@"thumb"];
    [partnersMapping mapKeyPath:@"picture" toAttribute:@"picture"];
    return partnersMapping;
}

- (RKObjectMapping *)photoCategoryMapping
{
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[PhotoCategory class]];
    
    
    [partnersMapping mapKeyPath:@"id" toAttribute:@"categoryId"];
    [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"thumb" toAttribute:@"thumb"];
    [partnersMapping mapKeyPath:@"num_photos" toAttribute:@"numPhotos"];
    return partnersMapping;
    
}

- (RKObjectMapping *) eventsMapping
{
    RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[Event class]];
    [mapping mapKeyPath:@"id" toAttribute:@"eventID"];
    [mapping mapKeyPath:@"title" toAttribute:@"title"];
    [mapping mapKeyPath:@"is_featured_event" toAttribute:@"featured"];
    [mapping mapKeyPath:@"category" toAttribute:@"categoryName"];
    [mapping mapKeyPath:@"description" toAttribute:@"details"];
    [mapping mapKeyPath:@"image_url" toAttribute:@"imageURL"];
    [mapping mapKeyPath:@"start_time" toAttribute:@"startTime"];
    [mapping mapKeyPath:@"end_time" toAttribute:@"endTime"];
    [mapping mapRelationship:@"location" withMapping:[self locationMapping]];
    [mapping setDateFormatters:[NSArray arrayWithObject:[self dateFormatter]]];    
    return mapping;
}

- (RKObjectMapping *) eventCategoriesMapping
{
    RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[EventCategory class]];
    [mapping mapKeyPath:@"id" toAttribute:@"categoryId"];
    [mapping mapKeyPath:@"title" toAttribute:@"title"];
    return mapping;
}

- (RKObjectMapping *) locationMapping
{
    RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[Location class]];
    [mapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
    [mapping mapKeyPath:@"longitude" toAttribute:@"longitude"];
    [mapping mapKeyPath:@"zip" toAttribute:@"zip"];
    [mapping mapKeyPath:@"address" toAttribute:@"address"];
    [mapping mapKeyPath:@"name" toAttribute:@"name"];
    [mapping mapKeyPath:@"phone" toAttribute:@"phone"];
    [mapping mapKeyPath:@"website" toAttribute:@"website"];
    [mapping mapKeyPath:@"city" toAttribute:@"city"];

    return mapping;
}

- (RKObjectMapping *) partnerMapping
{
    RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[Partner class]];
    [mapping mapKeyPath:@"id" toAttribute:@"partnterId"];
    [mapping mapKeyPath:@"name" toAttribute:@"name"];
    [mapping mapKeyPath:@"itunes_app_id" toAttribute:@"iTunesAppId"];
    [mapping mapKeyPath:@"facebook_app_id" toAttribute:@"facebookAppId"];
    [mapping mapKeyPath:@"image" toAttribute:@"headerImageUrl"];
    [mapping mapKeyPath:@"website_url" toAttribute:@"webSiteUrl"];
    
    [mapping hasMany:@"locations" withMapping:[self locationMapping]];
    
    return mapping;
    
}

- (RKObjectMapping *) sectionMapping
{
    RKObjectMapping * mapping = [RKObjectMapping mappingForClass:[Section class]];
    [mapping mapKeyPath:@"id" toAttribute:@"sectionId"];
    [mapping mapKeyPath:@"display_name" toAttribute:@"displayName"];
    [mapping mapKeyPath:@"image_url" toAttribute:@"imageUrl"];
    [mapping mapKeyPath:@"partnerID" toAttribute:@"partner_id"];
    [mapping mapKeyPath:@"section_name" toAttribute:@"name"];
    [mapping mapKeyPath:@"url" toAttribute:@"url"];
    [mapping mapKeyPath:@"ui_type" toAttribute:@"uiType"];    
    return mapping;
}



#pragma mark -
#pragma mark private methods

- (NSDateFormatter *) dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter autorelease];
}

@end
