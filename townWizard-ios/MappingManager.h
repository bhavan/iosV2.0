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
- (RKObjectMapping *) partnerMapping;
- (RKObjectMapping *) sectionMapping;
- (RKObjectMapping *) eventCategoriesMapping;
- (RKObjectMapping *) photoCategoryMapping;
- (RKObjectMapping *) photoMapping;
- (RKObjectMapping *) videoMapping;
@end
