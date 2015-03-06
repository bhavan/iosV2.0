//
//  GPModelFactory.m
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "ModelFactory.h"
#import "BlocksKit.h"
#import "EasyMapping.h"
#import "EKMappingProtocol.h"

@implementation ModelFactory

+(instancetype)factoryWithObjectClass:(Class)objectClass
{
    NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)]);
    
    ModelFactory * factory = [self new];
    factory.requiresObjectCreation = YES;
    factory.objectClass = objectClass;
    return factory;
}

-(id)fromJSONObject:(id)JSON
{
    id unrootedJSON = JSON;
    if (self.rootPath)
    {
        unrootedJSON = [JSON valueForKeyPath:self.rootPath];
    }
    
    if (!self.requiresObjectCreation)
    {
        return unrootedJSON;
    }
    if ([unrootedJSON isKindOfClass:[NSArray class]]) {
        return [self fromArray:unrootedJSON];
    } else if ([unrootedJSON isKindOfClass:[NSDictionary class]]) {
        return [self fromDictionary:unrootedJSON];
    } else {
        return nil;
    }
}

- (id)fromArray:(NSArray *)array {
    return [array bk_map:^id(id obj) {
        return [self fromDictionary:obj];
    }];
}

- (id)fromDictionary:(NSDictionary *)dictionary
{
    return [self createFromAttributes:dictionary];
}

-(id)createFromAttributes:(NSDictionary *)attributes
{
    if (self.objectClass)
    {
        return [[self.objectClass alloc] initWithProperties:attributes];
    }
    
    return attributes;
}

@end
