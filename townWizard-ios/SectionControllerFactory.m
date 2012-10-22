//
//  SectionControllerFactory.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import "SectionControllerFactory.h"
#import "SectionController.h"
#import "Section.h"

#import "SubMenuViewController.h"
#import "PhotoCategoriesViewController.h"
#import "VideosViewController.h"

@implementation SectionControllerFactory

- (id<SectionController>) sectionControllerForSection:(Section *) section
{
    Class ControllerClass = [self controllerClassForSection:section];
    if ([ControllerClass conformsToProtocol:@protocol(SectionController)]) {
        id<SectionController> controller = [[ControllerClass new] autorelease];
        return controller;
    }
    return nil;
}

- (Class) controllerClassForSection:(Section *) section
{
    if ([[section uiType] isEqualToString:@"webview"]) {
        return [SubMenuViewController class];
    }
    else if ([[section name] isEqual:@"Photos"]) {
        return [PhotoCategoriesViewController class];
    }
    else if ([section.name isEqual:@"Videos"]) {
        return [VideosViewController class];
    }
    return [NSNull class];
}

@end
