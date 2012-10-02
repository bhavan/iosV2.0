//
//  Partner.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import <Foundation/Foundation.h>

@interface Partner : NSObject
{    
    NSString *partnterId;
    NSString *name;
    NSString *iTunesAppId;
    NSString *facebookAppId;
    NSString *headerImageUrl;
    NSString *webSiteUrl;
}

@property (nonatomic, retain) NSString *partnterId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iTunesAppId;
@property (nonatomic, retain) NSString *facebookAppId;
@property (nonatomic, retain) NSString *headerImageUrl;
@property (nonatomic, retain) NSString *webSiteUrl;

+ (RKObjectMapping *)objectMapping;


@end
