//
//  VideosRequestFactory.h
//  townWizard-ios
//
//  Created by Denys Telezhkin on 06.03.15.
//
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

@interface VideosRequestFactory : NSObject

+(APIRequest *)videosRequestForURL:(NSString *)url;

@end
