//
//  Video.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"

@interface Video : EKObjectModel

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *url;

//build youtube thumb url with video url
@property (nonatomic, readonly) NSURL *youtubeThumbURL;

@end
