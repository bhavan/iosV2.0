//
//  BaseUploadViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import <UIKit/UIKit.h>

@class PhotoUploadView;
@class Partner;

@interface BaseUploadViewController : GAITrackedViewController <UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PhotoUploadView *uploadView;
    Partner *partner;
}

@property (nonatomic, retain) Partner *partner;

@end
