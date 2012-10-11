//
//  VideoViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/11/12.
//
//

#import "VideoViewController.h"
#import "TownWIzardNavigationBar.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize webView;
@synthesize videoUrl;
@synthesize customNavigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.videoUrl)
    {
    NSString* sEmbedHTML =[NSString stringWithFormat:@"<!doctype html>\
                           <html>\
                           <style>body{padding:0;margin:0; background-color: black;}</style>\
                           <iframe width=\"320\" height=\"367\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           </html>", self.videoUrl];
    [self.webView loadHTMLString:sEmbedHTML baseURL:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.customNavigationBar.menuButton addTarget:self
                                            action:@selector(menuButtonPressed)
                                  forControlEvents:UIControlEventTouchUpInside];  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customNavigationBar.menuButton removeTarget:self
                                               action:@selector(menuButtonPressed)
                                     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)menuButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)dealloc {
    [webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
