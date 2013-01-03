//
//  VideoViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/11/12.
//
//

#import <UIKit/UIKit.h>

@class TownWizardNavigationBar;

@interface VideoViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *videoUrl;

@end
