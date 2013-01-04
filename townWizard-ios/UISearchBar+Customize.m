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
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
        else if([subview isKindOfClass:[UITextField class]])
        {
            UITextField *tf = (UITextField *)subview;
            [tf setBackgroundColor:[UIColor clearColor]];
            [tf setBackground: [UIImage imageNamed:@"searchBar"] ];
            [tf setBorderStyle:UITextBorderStyleNone];
            [tf setTextColor:[UIColor colorWithRed:203.0f/255.0f green:0 blue:0 alpha:1.0f]];
            [tf setFont:[UIFont boldSystemFontOfSize:16.0f]];
        }
    }
}


@end
