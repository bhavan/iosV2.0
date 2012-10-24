//
//  MappingManager.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface MappingManager : NSObject

+ (id) sharedInstance;

- (RKObjectMapping *) eventsMapping;
- (RKObjectMapping *) locationMapping;

@end
