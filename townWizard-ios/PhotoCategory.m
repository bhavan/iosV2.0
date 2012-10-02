//
//  PhotoCategory.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "PhotoCategory.h"

@implementation PhotoCategory

@synthesize categoryId, name, thumb, numPhotos;

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping * partnersMapping = [RKObjectMapping mappingForClass:[PhotoCategory class]];
    
    
    [partnersMapping mapKeyPath:@"id" toAttribute:@"categoryId"];
        [partnersMapping mapKeyPath:@"name" toAttribute:@"name"];
        [partnersMapping mapKeyPath:@"thumb" toAttribute:@"thumb"];
        [partnersMapping mapKeyPath:@"num_photos" toAttribute:@"numPhotos"];
    return partnersMapping;
    
}


@end
