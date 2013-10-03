//
//  VideoViewController.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/11/12.
//
//

#import <UIKit/UIKit.h>

@interface VideoViewController : GAITrackedViewController <UIWebViewDelegate>
{
    UIWebView *webView;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *videoUrl;

@end
