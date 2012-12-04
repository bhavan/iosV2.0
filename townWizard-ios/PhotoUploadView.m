//
//  PhotoUploadView.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import "PhotoUploadView.h"
#import "EventSectionHeader.h"

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
    self = [super initWithFrame:CGRectMake(0, 0, 320, 27)];
    if(self)
    {
        EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:self.frame];
        [self addSubview:header];
        [header release];
        parentController = parent;
        UILabel *lblPhotoHeader = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 250, 22)];
        lblPhotoHeader.text = @"UPLOAD YOUR PHOTOS";
        lblPhotoHeader.font = [UIFont systemFontOfSize:13.0];
        lblPhotoHeader.backgroundColor = [UIColor clearColor];
        lblPhotoHeader.textColor = [UIColor blackColor];
        [self addSubview:lblPhotoHeader];
        [lblPhotoHeader release];
        
        UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCamera setImage:[UIImage imageNamed:@"Btn-Camera.png"] forState:UIControlStateNormal];
        btnCamera.frame = CGRectMake(282, 0, 25, 25);
        [btnCamera addTarget:parentController
                      action:@selector(cameraButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamera];


    }
    
    return self;
}



@end
