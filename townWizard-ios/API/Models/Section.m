//
//  Section.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import "Section.h"

@implementation Section

- (void)dealloc
{
    [_sectionId release];
    [_displayName release];
    [_name release];
    [_url release];
    [_imageUrl release];
    [_partnerID release];
    [_uiType release];
    [super dealloc];
}

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:self];
    [mapping mapPropertiesFromDictionary:@{
                                           @"id":@"sectionId",
                                           @"display_name":@"displayName",
                                           @"image_url":@"imageUrl",
                                           @"partnerID":@"partner_id",
                                           @"section_name":@"name",
                                           @"url":@"url",
                                           @"ui_type":@"uiType"
                                           }];
    return [mapping autorelease];
}

@end
