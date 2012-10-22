//
//  SectionController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@class Partner;
@class Section;

@protocol SectionController <NSObject>
- (void) setSection:(Section *) section;
@end
