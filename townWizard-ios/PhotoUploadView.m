//
//  PhotoUploadView.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import "PhotoUploadView.h"

@implementation PhotoUploadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithParentController:(UIViewController *)parent
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 31)];
    if(self)
    {
       
        parentController = parent;
        UILabel *lblPhotoHeader = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 250, 31)];
        lblPhotoHeader.text = @"UPLOAD YOUR PHOTOS";
        lblPhotoHeader.font = [UIFont systemFontOfSize:15.0];
        lblPhotoHeader.backgroundColor = [UIColor clearColor];
        lblPhotoHeader.textColor = [UIColor blackColor];
        [self addSubview:lblPhotoHeader];
        [lblPhotoHeader release];
        
        UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCamera setImage:[UIImage imageNamed:@"Btn-Camera.png"] forState:UIControlStateNormal];
        btnCamera.frame = CGRectMake(282, 0, 29, 28);
        [btnCamera addTarget:parentController
                      action:@selector(cameraButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamera];


    }
    
    return self;
}



@end
