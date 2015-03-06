//
//  PartnerRequestFactory.h
//  townWizard-ios
//
//  Created by Denys Telezhkin on 06.03.15.
//
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

@interface PartnerRequestFactory : NSObject

+(APIRequest *)partnerDetailsRequestWithPartnerId:(NSString *)partnerID;
+(APIRequest *)partnerSectionsRequestWithPartnerId:(NSString *)partnerID;

@end
