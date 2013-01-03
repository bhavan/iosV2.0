//
//  SectionImageManager.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/29/12.
//
//

#import <Foundation/Foundation.h>

@class Section;

@interface SectionImageManager : NSObject
{
    NSDictionary *images;
}

+ (id) sharedInstance;

- (UIImage *) imageForSection:(Section *) section;

@end
