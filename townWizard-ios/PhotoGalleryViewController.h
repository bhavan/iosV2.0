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
#import "BaseUploadViewController.h"

@class Partner;

@interface PhotoGalleryViewController : BaseUploadViewController
    <AQGridViewDataSource,
    AQGridViewDelegate,
    RKObjectLoaderDelegate,
    MWPhotoBrowserDelegate>
{
    int currentIndex;
}

@property (retain, nonatomic) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) PhotoCategory *category;

@end
