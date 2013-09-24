//
//  UISearchBar+Customize.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/4/13.
//
//

#import "UISearchBar+Customize.h"

@implementation UISearchBar (Customize)

- (void)customizeSearchBar
{
    [[UISearchBar appearance] setScopeBarButtonBackgroundImage:nil forState:UIControlStateNormal];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar"]
                                                   forState:UIControlStateNormal];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
}


@end
