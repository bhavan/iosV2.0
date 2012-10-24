//
//  SectionControllerFactory.m
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import "SectionControllerFactory.h"
#import "Section.h"

#import "SubMenuViewController.h"
#import "PhotoCategoriesViewController.h"
#import "VideosViewController.h"
#import "EventsViewController.h"

@implementation SectionControllerFactory

- (UIViewController *) sectionControllerForSection:(Section *) section
{
    Class ControllerClass = [self controllerClassForSection:section];
    return [[ControllerClass new] autorelease];
}

- (Class) controllerClassForSection:(Section *) section
{
    if ([[section uiType] isEqualToString:@"webview"]) {
        return [SubMenuViewController class];
    }
    else if ([[section name] isEqual:@"Photos"]) {
        return [PhotoCategoriesViewController class];
    }
    else if ([[section name] isEqual:@"Videos"]) {
        return [VideosViewController class];
    }
    else if([[section name] isEqualToString:@"Events"]) {
        return [EventsViewController class];
    }
    return [NSNull class];
}

- (UIViewController *) defaultController
{
    return [[SubMenuViewController new] autorelease];
}

@end
