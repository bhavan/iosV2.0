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
    uploadView = [[PhotoUploadView alloc] initWithParentController:self];
    [self.view addSubview:uploadView];

}

- (void)cameraButtonPressed:(id)sender {
	AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *menu = [[UIActionSheet alloc]
							   initWithTitle: @""
							   delegate:self
							   cancelButtonTitle:@"Cancel"
							   destructiveButtonTitle:nil
							   otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
		[menu setTag:1];
		[menu showInView:appdelegate.window];
		[menu release];
	}
	else {
		UIActionSheet *menu = [[UIActionSheet alloc]
							   initWithTitle: @""
							   delegate:self
							   cancelButtonTitle:@"Cancel"
							   destructiveButtonTitle:nil
							   otherButtonTitles:@"Choose from Library", nil];
		[menu setTag:2];
		[menu showInView:appdelegate.window];
		[menu release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 2) //Cancel button
		return;
	
	UIImagePickerController* ImageController = [[UIImagePickerController alloc] init];
	//ImageController.allowsImageEditing = YES;
	ImageController.delegate = self;
	
	if(actionSheet.tag == 1) {
		if(buttonIndex == 1) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
				ImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
		else if(buttonIndex == 0) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				ImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
	}
	else if(actionSheet.tag == 2) {
		if(buttonIndex == 0) {
			if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
				ImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:ImageController animated:YES];
			}
		}
	}
	
	[ImageController release];
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
	viewController.m_photo = image;	
    [picker presentModalViewController:viewController animated:YES];    
	[viewController release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [uploadView release];
    [super dealloc];
}

@end
