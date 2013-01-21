//
//  BaseUploadViewController.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/12/12.
//
//

#import "BaseUploadViewController.h"
#import "PhotoUploadView.h"
#import "AddCaptionViewController.h"
#import "AppDelegate.h"
#import "Partner.h"
#import "RequestHelper.h"

@interface BaseUploadViewController ()

@end

@implementation BaseUploadViewController

@synthesize partner;

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
    uploadView = [[PhotoUploadView alloc] init];
    [self.view addSubview:uploadView];
    [uploadView addUploadTarget:self action:@selector(cameraButtonPressed:)];
    self.partner = [[RequestHelper sharedInstance] currentPartner];
    
}

- (void)cameraButtonPressed:(id)sender
{
	AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
  
	UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @""
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Choose from Library", @"Take Photo", nil];
    [menu showInView:appdelegate.window];
    [menu release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 2) //Cancel button
		return;
	
	UIImagePickerController* imageController = [[UIImagePickerController alloc] init];
	imageController.delegate = self;
	UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(buttonIndex == 0)
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 1)
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;        
    }
	if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        imageController.sourceType = sourceType;
        [self presentModalViewController:imageController animated:YES];
    }
	[imageController release];
}

#pragma mark -
#pragma mark <UIImagePickerControllerDelegate> Methods

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
	
	//[(PhotoGalleryViewController *)parent dismissModalViewControllerAnimated:YES];
	
	AddCaptionViewController *viewController = [[AddCaptionViewController alloc]
                                                initWithNibName:@"AddCaptionViewController"
                                                bundle:nil];
    
    viewController.partnerSiteURL = self.partner.webSiteUrl;
	viewController.photo = image;
    [picker presentModalViewController:viewController animated:YES];
	[viewController release];
}


- (void)dealloc
{
    [uploadView release];
    [partner release];
    [super dealloc];
}

@end
