//
//  VideoViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/11/12.
//
//

#import "VideoViewController.h"

@interface VideoViewController ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation VideoViewController
@synthesize webView;
@synthesize videoUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.videoUrl)
    {
        //Do not delete. New way to play videos
        /* NSString* sEmbedHTML =[NSString stringWithFormat:@"<!doctype html>\
         <html>\
         <style>body{padding:0;margin:0; background-color: black;}</style>\
         <iframe width=\"320\" height=\"367\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
         </html>", self.videoUrl];
         [self.webView loadHTMLString:sEmbedHTML baseURL:nil];*/
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]]];
    }
}


- (void)dealloc
{
    [webView release];
    [videoUrl release];
    [_activityIndicator release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

#pragma mark - UIWebViewDelegate 

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[self activityIndicator] startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[self activityIndicator] stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[self activityIndicator] stopAnimating];
    [UIAlertView showConnectionProblemMessage];
}

@end
