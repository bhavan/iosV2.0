//
//  SectionControllerFactory.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import <Foundation/Foundation.h>

@class Section;

@protocol SectionController;

@interface SectionControllerFactory : NSObject

- (UIViewController *) sectionControllerForSection:(Section *) section;
- (UIViewController *) defaultController;

@end
