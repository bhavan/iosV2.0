//
//  GPParsedError.h
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsedError : NSObject

@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSString * formattedErrorMessage;

+(instancetype)parsedErrorWithError:(NSError *)error fromJSON:(id)JSON;

@end
