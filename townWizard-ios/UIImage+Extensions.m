//
//  UIImage+Extensions.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/11/13.
//
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (UIImage*)buildThumbImage
{
	CGSize thumbSize = CGSizeMake(60.0, 60.0);
	CGSize size = CGSizeMake(58.0, 58.0);
	CGSize sizeImage = self.size;
	
	CGFloat fWidth = size.width;
	CGFloat fHeight = size.height;
	
	if(sizeImage.width > sizeImage.height)
    {
		fHeight = (sizeImage.height * fWidth) / sizeImage.width;
	}
	else {
		fWidth = (sizeImage.width * fHeight) / sizeImage.height;
	}
	
	CGFloat fXOffset = 0.0;
	if(fWidth < size.width)
    {
		fXOffset = (size.width - fWidth) / 2.0;
	}
	
	CGFloat fYOffset = 0.0;
	if(fHeight < size.height)
    {
		fYOffset = (size.height - fHeight) / 2.0;
	}
	
	UIGraphicsBeginImageContext(thumbSize);
	[[UIImage imageNamed:@"Image-Border.png"] drawInRect:CGRectMake(0.0, 0.0,
                                                                    thumbSize.width, thumbSize.height)];
	
	[self drawInRect:CGRectMake(fXOffset + 1.0, fYOffset + 1.0, fWidth, fHeight)];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

@end
