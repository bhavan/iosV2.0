//
//  FacebookFriend.m
//  GenericApp
//
//  Created by John Doe on 6/17/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookFriend.h"


@implementation FacebookFriend

- (id) initWithInfo:(NSDictionary *)info {
    self = [self init];
    if (self) {
        self.name = [info objectForKey:@"name"];
        self.facebookId = [info objectForKey:@"id"];
    }
    return self;
}

- (void) loadImage {
    NSString *avatarString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",
                              self.facebookId];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:avatarString]];
    self.avatar = [UIImage imageWithData:imageData];
    [imageData release];
}

#pragma mark - Memory management

- (void) dealloc {
    self.name = nil;
    self.facebookId = nil;
    self.avatar = nil;
    [super dealloc];
}

#pragma mark -

@synthesize name;
@synthesize facebookId;
@synthesize avatar;
@end
