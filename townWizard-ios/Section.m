//
//  Section.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import "Section.h"

@implementation Section

@synthesize sectionId, name, displayName, url, imageUrl, partnerId, subSections, uiType;

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[Section class]];
    [partnersMapping mapKeyPath:@"id" toAttribute:@"sectionId"];
    [partnersMapping mapKeyPath:@"display_name" toAttribute:@"displayName"];
    [partnersMapping mapKeyPath:@"image_url" toAttribute:@"imageUrl"];
    [partnersMapping mapKeyPath:@"partner_id" toAttribute:@"partner_id"];
    [partnersMapping mapKeyPath:@"section_name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"url" toAttribute:@"url"];
    [partnersMapping mapKeyPath:@"ui_type" toAttribute:@"uiType"];
    
    return partnersMapping;
    
}

@end
