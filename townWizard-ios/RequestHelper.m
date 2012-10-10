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


#define REQUEST_TIMEOUT 30


@implementation RequestHelper

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
    
    NSString *lastToken = [RequestHelper md5:
                                    [NSString stringWithFormat:@"192.168.1.115%@", [RequestHelper md5:timeToken]]];
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

+ (void)partnersWithQuery:(NSString *)query andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.mappingProvider setObjectMapping:[Partner objectMapping] forKeyPath:@"data"];
    NSString *queryParam = @"";
    if(query) {
      /*  NSRange offsetRange = [query rangeOfString:@"&offset"];
        if(offsetRange.location > 0) {
            queryParam = [NSString stringWithFormat:@"q=%@",query];
        }
        else if(offsetRange.location == 0 && offsetRange.length > 0) {
            queryParam = [NSString stringWithFormat:@"%@",query];
        }*/
    }
    else {
     /*   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        queryParam = [NSString stringWithFormat:@"lat=%@&lon=%@",appDelegate.latitude, appDelegate.longitude];*/
    }
    NSString *resourcePath = [NSString stringWithFormat:@"apiv21/partner?%@",queryParam];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
    
}

+ (void)partnerWithId:(NSString *)partnerId andDelegate:(id <RKObjectLoaderDelegate>)delegate
{    
    RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    objectManager.client.baseURL = baseURL;
    [objectManager.mappingProvider setObjectMapping:[Partner objectMapping] forKeyPath:@"data"];    
    NSString *resourcePath = [NSString stringWithFormat:@"apiv21/partner/%@",partnerId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
    
}

+ (void)sectionsWithPartner:(Partner *)partner andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
     RKObjectManager *objectManager = [RKObjectManager sharedManager];
     RKObjectMapping *sectionMapping = [Section objectMapping];
    [sectionMapping mapKeyPath:@"sub_sections" toRelationship:@"subSections" withMapping:[Section objectMapping]];

    [objectManager.mappingProvider setObjectMapping:sectionMapping forKeyPath:@"data"];
    NSString *resourcePath = [NSString stringWithFormat:@"apiv21/section/partner/%@",partner.partnterId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];
}

+ (void)categoriesWithPartner:(Partner *)partner andSection:(Section *)section andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:[NSString stringWithFormat:@"%@/",partner.webSiteUrl]];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
   
  //   NSString *token = [RequestHelper xaccessTokenFromPartner:partner];
   
    objectManager.client.baseURL = baseURL;
  //  [objectManager.client.HTTPHeaders setValue:token forKey:@"X-ACCESS-TOKEN"];
    [objectManager.mappingProvider setObjectMapping:[PhotoCategory objectMapping] forKeyPath:@"data"];          

    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?debug=1",section.url] delegate:delegate];

}

+ (void)videosWithPartner:(Partner *)partner andSection:(Section *)section andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:partner.webSiteUrl];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
 //   NSString *token = [RequestHelper xaccessTokenFromPartner:partner];
    
    objectManager.client.baseURL = baseURL;
 //   [objectManager.client.HTTPHeaders setValue:token forKey:@"X-ACCESS-TOKEN"];
    [objectManager.mappingProvider setObjectMapping:[Video objectMapping] forKeyPath:@"data"];
    
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?debug=1",section.url] delegate:delegate];   
}


+ (void)photosWithPartner:(Partner *)partner fromCategory:(PhotoCategory *)category andDelegate:(id <RKObjectLoaderDelegate>)delegate
{
   // RKURL *baseURL = [RKURL URLWithBaseURLString:API_URL];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];    
  //  NSString *token = [RequestHelper xaccessTokenFromPartner:partner];
    

    [objectManager.mappingProvider setObjectMapping:[Photo objectMapping] forKeyPath:@"data"];
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/api2.1/album?id=%@&debug=1",partner.webSiteUrl,category.categoryId];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:delegate];

}

@end
