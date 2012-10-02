//
//  Video.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface Video : NSObject
{
    NSString *name;
    NSString *thumb;
    NSString *url;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *url;

+ (RKObjectMapping *)objectMapping;

@end
