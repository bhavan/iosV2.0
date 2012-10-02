//
//  Video.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "Video.h"

@implementation Video


@synthesize name, thumb, url;

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[Video class]];
    
    [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"thumb" toAttribute:@"thumb"];
    [partnersMapping mapKeyPath:@"url" toAttribute:@"url"];
    return partnersMapping;
    
}

@end
