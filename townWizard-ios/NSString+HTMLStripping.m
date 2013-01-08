//
//  NSString+HTMLStripping.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/8/13.
//
//

#import "NSString+HTMLStripping.h"

@implementation NSString (HTMLStripping)


-(NSString *) stringByStrippingHTML
{
    NSRange r;
    NSString *result = [[self copy] autorelease];
    while ((r = [result rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        result = [result stringByReplacingCharactersInRange:r withString:@""];
    return result;
}


@end
