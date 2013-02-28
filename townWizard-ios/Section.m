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

@end
