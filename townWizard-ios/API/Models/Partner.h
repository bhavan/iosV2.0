//
//  Partner.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import <Foundation/Foundation.h>
#import "EKObjectModel.h"
#import "Location.h"

@interface Partner : EKObjectModel

@property (nonatomic, retain) NSString *partnerId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iTunesAppId;
@property (nonatomic, retain) NSString *facebookAppId;
@property (nonatomic, retain) NSString *headerImageUrl;
@property (nonatomic, retain) NSString *webSiteUrl;
@property (nonatomic, retain) NSArray *locations;

@end
