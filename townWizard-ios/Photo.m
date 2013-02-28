//
//  Photo.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "Photo.h"

@implementation Photo

- (void)dealloc
{
    [_name release];
    [_thumb release];
    [_picture release];
    [super dealloc];
}


@end
