//
//  VideoViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/11/12.
//
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize webView;
@synthesize videoUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {        

    }
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


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)dealloc
{
    [webView release];
    [videoUrl release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
