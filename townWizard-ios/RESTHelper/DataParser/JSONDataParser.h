//
//  JSONDataParser.h
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBJsonParser;

@interface JSONDataParser : NSObject {
    NSString *jsonString;
    id parsedJsonString;
    NSError *error;
}

- (id) initWithJSONString:(NSString *) jsonString;
- (id) getResponseData;

@property (nonatomic,readonly) NSString *jsonString;
@property (nonatomic,readonly) NSError *error;

@end
