//
//  RequestHelper.m
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestHelper.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "Section.h"
#import "Photo.h"
#import "PhotoCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import "Video.h"

#import "MappingManager.h"

#define REQUEST_TIMEOUT 30

static RequestHelper *requestHelper = nil;

@implementation RequestHelper

+ (id) sharedInstance
{
    @synchronized (self) {
        if (requestHelper == nil) {
            requestHelper = [[self alloc] init];
        }
    }
    return requestHelper;
}


+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSString *)xaccessTokenFromPartner:(Partner *)partner
{
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSString *timeToken = [[RequestHelper md5:timeStamp] substringToIndex:8];
    [timeStamp release];
    NSString *webSite = [partner.webSiteUrl lastPathComponent];
    NSString *lastToken = [RequestHelper md5:
                           [NSString stringWithFormat:@"%@%@",webSite, [RequestHelper md5:timeToken]]];
    
    NSString *resultToken = [NSString stringWithFormat:@"%@%@",lastToken, timeToken];
    return resultToken;
}

+ (RKObjectManager *)defaultObjectManager
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    return objectManager;
}

+ (void)partnersWithQuery:(NSString *)query offset:(NSInteger)offset andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    NSString *queryParam = @"";
    if(query && query.length > 0)
    {
        queryParam = [NSString stringWithFormat:@"q=%@",query];
    }
    else
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        queryParam = [NSString stringWithFormat:@"lat=%@&lon=%@",appDelegate.latitude, appDelegate.longitude];
    }
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    objectManager.client.baseURL = baseURL;
    [objectManager.mappingProvider setObjectMapping:[Partner objectMapping] forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:@"/partner?%@&offset=%d",queryParam,offset];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
}


+ (void)partnerWithId:(NSString *)partnerId andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    objectManager.client.baseURL = baseURL;
    [objectManager.mappingProvider setObjectMapping:[Partner objectMapping] forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:@"/partner/%@",partnerId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
    
}

+ (void)sectionsWithPartner:(Partner *)partner andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKObjectMapping *sectionMapping = [Section objectMapping];
    [sectionMapping mapKeyPath:@"sub_sections" toRelationship:@"subSections" withMapping:[Section objectMapping]];
    
    [objectManager.mappingProvider setObjectMapping:sectionMapping forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:@"/section/partner/%@",partner.partnterId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
}

+ (void)modelsListWithMapping:(RKObjectMapping *)objectMapping
                  fromPartner:(Partner *)partner
                   andSection:(Section *)section
                 withDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:partner.webSiteUrl];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];    
    NSString *token = [RequestHelper xaccessTokenFromPartner:partner];
    
    objectManager.client.baseURL = baseURL;
    [objectManager.client.HTTPHeaders setValue:token forKey:TOKEN_KEY];
    [objectManager.mappingProvider setObjectMapping:objectMapping forKeyPath:@"data"];    
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@",section.url] delegate:delegate];
}

+ (void)categoriesWithPartner:(Partner *)partner andSection:(Section *)section andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    [RequestHelper modelsListWithMapping:[PhotoCategory objectMapping] fromPartner:partner andSection:section withDelegate:delegate];
}

+ (void)videosWithPartner:(Partner *)partner andSection:(Section *)section andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    [RequestHelper modelsListWithMapping:[Video objectMapping] fromPartner:partner andSection:section withDelegate:delegate];
}


+ (void)photosWithPartner:(Partner *)partner section:(Section *)section fromCategory:(PhotoCategory *)category andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.mappingProvider setObjectMapping:[Photo objectMapping] forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:
                              @"%@/%@?id=%@",
                              partner.webSiteUrl,
                              section.url,
                              category.categoryId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
    
}

#pragma mark -
#pragma mark load objects

- (RKObjectManager *) currentObjectManager
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:[[self currentPartner] webSiteUrl]];
    objectManager.client.baseURL = baseURL;

    NSString *token = [RequestHelper xaccessTokenFromPartner:[self currentPartner]];
    [objectManager.client.HTTPHeaders setValue:token forKey:TOKEN_KEY];
    
    return objectManager;    
}

- (void) loadVideosWithDelegate:(id<RKObjectLoaderDelegate>) delegate
{
    RKObjectManager *objectManager = [self currentObjectManager];
    [objectManager.mappingProvider setObjectMapping:[Video objectMapping] forKeyPath:@"data"];
    [objectManager loadObjectsAtResourcePath:[[self currentSection] url] delegate:delegate];
}

- (void) loadPhotoCategoriesWithDelegate:(id<RKObjectLoaderDelegate>) delegate
{
    RKObjectManager *objectManager = [self currentObjectManager];
    [objectManager.mappingProvider setObjectMapping:[PhotoCategory objectMapping] forKeyPath:@"data"];
    [objectManager loadObjectsAtResourcePath:[[self currentSection] url] delegate:delegate];
}

- (void) loadPhotosFromCategory:(PhotoCategory *) category delegate:(id<RKObjectLoaderDelegate>) delegate
{
    RKObjectManager *objectManager = [self currentObjectManager];
    [objectManager.mappingProvider setObjectMapping:[Photo objectMapping] forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@?id=%@",
                              [[self currentPartner] webSiteUrl],
                              [[self currentSection] url],
                              [category categoryId]];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
}

- (void) loadEventsWithDelegate:(id<RKObjectLoaderDelegate>) delegate
{
    RKObjectManager *objectManager = [self currentObjectManager];
    [[objectManager mappingProvider] setObjectMapping:[[MappingManager sharedInstance] eventsMapping]
                                           forKeyPath:@"data"];
    [objectManager loadObjectsAtResourcePath:[[self currentSection] url]
                                    delegate:delegate];
}

@end
