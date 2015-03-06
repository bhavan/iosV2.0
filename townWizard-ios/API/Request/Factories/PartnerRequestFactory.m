//
//  PartnerRequestFactory.m
//  townWizard-ios
//
//  Created by Denys Telezhkin on 06.03.15.
//
//

#import "PartnerRequestFactory.h"
#import "Partner.h"
#import "Section.h"

@implementation PartnerRequestFactory

+(APIRequest *)partnerDetailsRequestWithPartnerId:(NSString *)partnerID
{
    NSString * path = [NSString stringWithFormat:@"partner/%@",partnerID];
    APIRequest * request = [APIRequest requestWithPath:path];
    request.modelFactory = [ModelFactory factoryWithObjectClass:[Partner class]];
    request.modelFactory.rootPath = @"data";
    return request;
}

+(APIRequest *)partnerSectionsRequestWithPartnerId:(NSString *)partnerID
{
    NSString * path = [NSString stringWithFormat:@"section/partner/%@",partnerID];
    APIRequest * request = [APIRequest requestWithPath:path];
    request.modelFactory = [ModelFactory factoryWithObjectClass:[Section class]];
    request.modelFactory.rootPath = @"data";
    return request;
}

@end
