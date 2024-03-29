//
//  RequestHelper.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>
#import "Partner.h"

@class Section;
@class PhotoCategory;

@interface RequestHelper : NSObject

@property (nonatomic, retain) Partner *currentPartner;
@property (nonatomic, retain) Section *currentSection;


- (RKObjectManager *) currentObjectManager;

+ (id) sharedInstance;

+ (NSString *) md5:(NSString *) input;
+ (NSString *)xaccessTokenFromPartner:(Partner *)partner;

+ (void)partnersWithQuery:(NSString *)query offset:(NSInteger)offset andDelegate:(id <RKObjectLoaderDelegate>)delegate;

+ (void)partnerWithId:(NSString *)partnerId
          andDelegate:(id <RKObjectLoaderDelegate>)delegate;

+ (void)categoriesWithPartner:(Partner *)partner
                   andSection:(Section *)section
                  andDelegate:(id <RKObjectLoaderDelegate>)delegate;

+ (void)photosWithPartner:(Partner *)partner section:(Section *)section fromCategory:(PhotoCategory *)category andDelegate:(id <RKObjectLoaderDelegate>)delegate;

+ (void)videosWithPartner:(Partner *)partner
               andSection:(Section *)section
              andDelegate:(id <RKObjectLoaderDelegate>)delegate;

+ (void)modelsListWithMapping:(RKObjectMapping *)objectMapping
                  fromPartner:(Partner *)partner
                   andSection:(Section *)section
                 withDelegate:(id <RKObjectLoaderDelegate>)delegate;


- (void) loadVideosWithDelegate:(id<RKObjectLoaderDelegate>) delegate;
- (void) loadPhotoCategoriesWithDelegate:(id<RKObjectLoaderDelegate>) delegate;
- (void) loadPhotosFromCategory:(PhotoCategory *) category delegate:(id<RKObjectLoaderDelegate>) delegate;
- (void) loadEventsCategoriesUsingBlock:(void(^)(RKObjectLoader *)) block;
- (void) loadEventsUsingBlock:(void(^)(RKObjectLoader *)) block;
- (void) loadFeaturedEventUsingBlock:(void(^)(RKObjectLoader *)) block;
- (void) loadEventsWithDatePeriod:(NSDate *)startDate end:(NSDate *)endDate
                         delegate:(id<RKObjectLoaderDelegate>) delegate;
- (void) loadPartnerDetails:(NSString *) partnerID
                 usingBlock:(void(^)(RKObjectLoader *)) block;
- (void) loadSectionsUsingBlock:(void(^)(RKObjectLoader *)) block;

- (NSData *)uploadRequestDataForImage:(UIImage *)image
                              caption:(NSString *)caption
                             userName:(NSString *)name;

@end
