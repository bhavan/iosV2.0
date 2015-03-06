//
//  VideosRequestFactory.m
//  townWizard-ios
//
//  Created by Denys Telezhkin on 06.03.15.
//
//

#import "VideosRequestFactory.h"
#import "Video.h"

@implementation VideosRequestFactory

+(APIRequest *)videosRequestForURL:(NSString *)url
{
    APIRequest * request = [APIRequest requestWithPath:url];
    request.requiresXAccessToken = YES;
    request.modelFactory = [ModelFactory factoryWithObjectClass:[Video class]];
    request.modelFactory.rootPath = @"data";
    return request;
}

@end
