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

static MappingManager *mappingManager = nil;

@implementation MappingManager

+ (id) sharedInstance
{
    @synchronized (self) {
        if (mappingManager == nil) {
            mappingManager = [[self alloc] init];
        }
    }
    return mappingManager;
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
