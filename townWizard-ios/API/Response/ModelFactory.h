//
//  GPModelFactory.h
//  GoPuffSDK
//
//  Created by Denys Telezhkin on 16.12.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"

@interface ModelFactory : NSObject

+(instancetype)factoryWithObjectClass:(Class<EKMappingProtocol>)objectClass;

@property (nonatomic, assign) Class objectClass;

/**
 Default - nil.
 */
@property (nonatomic, strong) NSString * rootPath;

/**
 Default - true.
 */
@property (nonatomic, assign) BOOL requiresObjectCreation;

-(id)fromJSONObject:(id)JSON;

@end
