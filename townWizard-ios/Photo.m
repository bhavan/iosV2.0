//
//  Photo.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "Photo.h"

@implementation Photo
@synthesize name, thumb, picture;

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[Photo class]];
    
    [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
    [partnersMapping mapKeyPath:@"thumb" toAttribute:@"thumb"];
    [partnersMapping mapKeyPath:@"picture" toAttribute:@"picture"];
    return partnersMapping;    
}

@end
