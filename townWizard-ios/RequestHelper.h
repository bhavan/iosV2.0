//
//  RequestHelper.h
//  townWizard-ios
//
//  Created by admin on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NSData* PerformURLRequest(NSURLRequest* request);

@interface RequestHelper : NSObject

+(NSURLRequest *)searchRequest:(NSString *)searchQuery;
+(NSURLRequest *)searchRequestUsingCurrentGeoposition; //This is search with current geoposition(3km approx)
+(NSURLRequest *)sectionsWithPartner:(NSString *)partnerId;
+(NSString*) formattedRequestStringWithParams:(NSDictionary*) params;
+(NSMutableURLRequest*) defaultRequest:(NSString*)apiPath params:(NSMutableDictionary*) paramsDict;
@end
