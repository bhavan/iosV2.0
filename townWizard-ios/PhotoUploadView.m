//
//  PhotoUploadView.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import "PhotoUploadView.h"
#import "EventSectionHeader.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface PhotoUploadView ()
@property (nonatomic, retain) UIButton *uploadButton;

- (void)initializeControls;
@end

@implementation PhotoUploadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (id)init
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) // ios 6 and lower
    {
        self = [super initWithFrame:CGRectMake(0, 0, 320, 34)];
    }
    else                                    // ios 7
    {
        self = [super initWithFrame:CGRectMake(0, 44, 320, 34)];
    }
    
    if(self)
    {
        [self initializeControls];
    }
    
    return self;
}

- (void)initializeControls
{
    int headerSectionY = (SYSTEM_VERSION_LESS_THAN(@"7.0")) ? 8 : 0;
    int lblPhotoY = (SYSTEM_VERSION_LESS_THAN(@"7.0")) ? 0 : -4;
    int uploadButtonY = (SYSTEM_VERSION_LESS_THAN(@"7.0")) ? 2 : -2;
    
    
    EventSectionHeader *header = [[EventSectionHeader alloc] initWithFrame:CGRectMake(0, headerSectionY, 320, 27)];
    [self addSubview:header];
    [header release];
    UILabel *lblPhotoHeader = [[UILabel alloc] initWithFrame:CGRectMake(8, lblPhotoY, 250, 32)];
    lblPhotoHeader.text = @"UPLOAD YOUR PHOTOS";
    lblPhotoHeader.font = [UIFont systemFontOfSize:13.0];
    lblPhotoHeader.backgroundColor = [UIColor clearColor];
    lblPhotoHeader.textColor = [UIColor blackColor];
    [self addSubview:lblPhotoHeader];
    [lblPhotoHeader release];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uploadButton setImage:[UIImage imageNamed:@"Btn-Camera.png"] forState:UIControlStateNormal];
    _uploadButton.frame = CGRectMake(282, uploadButtonY, 25, 25);
    [self addSubview:_uploadButton];
    
}

- (void)addUploadTarget:(id)target action:(SEL)action
{
    [_uploadButton addTarget:target
                  action:action
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    [self setUploadButton:nil];
    [super dealloc];
}



@end
