//
//  PhotoGalleryViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@class TownWizardNavigationBar;

@interface PhotoGalleryViewController : UIViewController <  AQGridViewDataSource,
AQGridViewDelegate,
RKObjectLoaderDelegate,
MWPhotoBrowserDelegate>
{
    NSArray *photos;
    AQGridView *gridView;;
}

@property (nonatomic, retain) TownWizardNavigationBar * customNavigationBar;
@property (retain, nonatomic) IBOutlet AQGridView *gridView;
@end
