//
//  Video.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "Video.h"

@implementation Video

- (void)dealloc
{    
    [_name release];
    [_thumb release];
    [_url release];
    [super dealloc];
}

@end
