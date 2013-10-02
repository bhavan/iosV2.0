//
//  Partner.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import <Foundation/Foundation.h>

#import "Location.h"

@interface Partner : NSObject

@property (nonatomic, retain) NSString *partnterId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iTunesAppId;
@property (nonatomic, retain) NSString *facebookAppId;
@property (nonatomic, retain) NSString *headerImageUrl;
@property (nonatomic, retain) NSString *webSiteUrl;
@property (nonatomic, retain) NSArray *locations;

@end
