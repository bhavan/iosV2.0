//
//  PhotoCategory.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "PhotoCategory.h"

@implementation PhotoCategory

- (void)dealloc
{
    [_categoryId release];
    [_thumb release];
    [_name release];
    [_numPhotos release];
    [super dealloc];
}

@end
