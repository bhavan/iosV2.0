//
//  RKJSONParserJSONKit.m
//  RestKit
//
//  Created by Jeff Arena on 3/16/10.
//  Copyright (c) 2009-2012 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RKJSONParserJSONKit.h"
#import "RKLog.h"

// Set Logging Component
#undef RKLogComponent
#define RKLogComponent lcl_cRestKitSupportParsers


// TODO: JSONKit serializer instance should be reused to enable leverage
// the internal caching capabilities from the JSONKit serializer
@implementation RKJSONParserJSONKit

- (NSDictionary *)objectFromString:(NSString *)string error:(NSError **)error
{
    RKLogTrace(@"string='%@'", string);
    NSData * utf8data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:utf8data options:NSJSONReadingAllowFragments error:error];
//    return [string objectFromJSONStringWithParseOptions:JKParseOptionStrict error:error];
}

- (NSString *)stringFromObject:(id)object error:(NSError **)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return [object JSONStringWithOptions:JKSerializeOptionNone error:error];
}

@end
