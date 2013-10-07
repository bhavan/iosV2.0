//
//  Video.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import "Video.h"

static NSString *const kYoutubeThumbURLFormat = @"http://img.youtube.com/vi/%@/0.jpg";

@implementation Video

- (void)dealloc
{    
    [_name release];
    [_thumb release];
    [_url release];
    [super dealloc];
}

- (NSURL *)youtubeThumbURL {
    NSString *youtubeVideoID = [self youtubeVideoID];
    NSString *urlString = [NSString stringWithFormat:kYoutubeThumbURLFormat,youtubeVideoID];
    return [NSURL URLWithString:urlString];
}

- (NSString *)youtubeVideoID {
    NSURL *videoURL = [NSURL URLWithString:[self url]];
    NSDictionary *queryParams = [self parseQueryString:[videoURL query]];
    return [queryParams objectForKey:@"v"];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];

    NSArray *queryComponents = [query componentsSeparatedByString:@"&"];
    for (NSString *param in queryComponents) {
        NSArray *paramComponents = [param componentsSeparatedByString:@"="];
        if([paramComponents count] < 2) {
            continue;
        }
        [queryParams setObject:paramComponents[1] forKey:paramComponents[0]];
    }
    
    return queryParams;
}

@end
