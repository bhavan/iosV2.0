//
//  SectionControllerFactory.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import <Foundation/Foundation.h>

@class Section;

@interface SectionControllerFactory : NSObject

- (UIViewController *) sectionControllerForSection:(Section *) section;

@end
