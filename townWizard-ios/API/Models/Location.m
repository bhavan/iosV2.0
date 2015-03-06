//
//  Location.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import "Location.h"

@implementation Location

- (void)dealloc
{
    [_latitude release];
    [_longitude release];
    [_zip release];
    [_address release];
    [_name release];
    [_phone release];
    [_website release];
    [_city release];
    
    [super dealloc];
}

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:self];
    [mapping mapPropertiesFromArray:@[@"latitude",@"longitude",@"zip",@"address",@"name",@"phone",@"website",@"city"]];
    return [mapping autorelease];
}

@end
