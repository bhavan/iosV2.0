//
//  SectionControllerFactory.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import <Foundation/Foundation.h>
#import "SectionController.h"

@class Section;

@protocol SectionController;

@interface SectionControllerFactory : NSObject

- (id<SectionController>) sectionControllerForSection:(Section *) section;

@end
