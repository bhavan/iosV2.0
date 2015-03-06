//
//  GPParsedError.m
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "ParsedError.h"

@implementation ParsedError

+(instancetype)parsedErrorWithError:(NSError *)error fromJSON:(id)JSON
{
    ParsedError * parsedError = [self new];
    parsedError.error = error;
    
    if ([JSON isKindOfClass:[NSDictionary class]])
    {
        parsedError.formattedErrorMessage = JSON[@"message"];
    }
    
    return parsedError;
}

@end
