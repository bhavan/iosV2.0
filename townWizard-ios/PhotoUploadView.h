//
//  PhotoUploadView.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import <UIKit/UIKit.h>

@interface PhotoUploadView : UIView
{
    UIViewController *parentController;
}


- (id)initWithParentController:(UIViewController *)parent;
@end
