//
//  FacebookFriend.h
//  GenericApp
//
//  Created by John Doe on 6/17/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FacebookFriend : NSObject {
    NSString *name;
    NSString *facebookId;
    UIImage *avatar;
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *facebookId;
@property (nonatomic,retain) UIImage *avatar;

- (id) initWithInfo:(NSDictionary *)info;
- (void) loadImage;

@end
