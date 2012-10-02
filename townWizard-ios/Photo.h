//
//  Photo.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
{
    NSString *name;
    NSString *thumb;
    NSString *picture;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *picture;

+ (RKObjectMapping *)objectMapping;

@end
