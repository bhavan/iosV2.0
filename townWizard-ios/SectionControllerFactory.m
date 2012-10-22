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
        [controller setSection:section];
        return controller;
    }
    return nil;
}


- (void) asd {
//    if ([section.uiType isEqualToString:@"webview"]) {
//        
//        SubMenuViewController *subMenu = [[SubMenuViewController alloc]
//                                          initWithNibName:@"SubMenuViewController" bundle:nil];
//        
//        subMenu.customNavigationBar = (TownWizardNavigationBar *)self.childNavigationController.navigationBar;
//        if(section != nil) {
//            subMenu.partner = self.partner;
//            subMenu.section = section;
//            NSString *urlString =  section.url;
//            NSString *urlHeader = [urlString substringToIndex:7];
//            NSString *sectionUrl = nil;
//            if([urlHeader isEqualToString:URL_HEADER]) {
//                sectionUrl = urlString;
//            }
//            else {
//                sectionUrl = [NSString stringWithFormat:@"%@/%@",
//                              self.partner.webSiteUrl,
//                              section.url];
//            }
//            subMenu.url = [sectionUrl stringByAppendingFormat:@"?&lat=%f&lon=%f",
//                           [AppDelegate sharedDelegate].doubleLatitude,
//                           [AppDelegate sharedDelegate].doubleLongitude];
//            
//        }
//        
//        [self.childNavigationController pushViewController:subMenu animated:YES];
//        [masterDetail toggleMasterView];
//        [subMenu release];
//        if ([section.name isEqual:@"Photos"])
//        {
//            dispatch_queue_t checkQueue =  dispatch_queue_create("check reachability", NULL);
//            dispatch_async(checkQueue, ^{
//                NSString * uploadUrl = [NSString stringWithFormat:@"%@%@",
//                                        self.partner.webSiteUrl,
//                                        uploadScriptURL];
//                if ([Reachability reachabilityWithURL:[NSURL URLWithString:uploadUrl]])
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [subMenu showUploadTitle];
//                    });
//                }
//            });
//            dispatch_release(checkQueue);
//        }
//        
//    }
//    else if ([section.name isEqual:@"Photos"])
//    {
//        PhotoCategoriesViewController *controller = [PhotoCategoriesViewController new];
//        controller.partner = self.partner;
//        controller.section = section;
//        controller.customNavigationBar = self.customNavigationBar;
//        [RequestHelper categoriesWithPartner:self.partner andSection:section andDelegate:controller];
//        [self.childNavigationController pushViewController:controller animated:YES];
//        [masterDetail toggleMasterView];
//        [controller release];
//    }
//    else if ([section.name isEqual:@"Videos"])
//    {
//        VideosViewController *controller = [VideosViewController new];
//        controller.partner = self.partner;
//        controller.section = section;
//        controller.customNavigationBar = self.customNavigationBar;
//        [RequestHelper videosWithPartner:self.partner andSection:section andDelegate:controller];
//        [self.childNavigationController pushViewController:controller animated:YES];
//        [masterDetail toggleMasterView];
//        [controller release];
//    }
}

- (id<SectionController>) sectionControllerOfClass:(Class) ControllserClass
{
    return [[ControllserClass new] autorelease];
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
