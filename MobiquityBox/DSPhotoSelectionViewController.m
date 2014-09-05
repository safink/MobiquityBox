//
//  DSPhotoSelectionViewController.m
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSPhotoSelectionViewController.h"
#import "DSDropboxAPI.h"
#import "DSImageUtils.h"
#import "AGAlertViewWithProgressbar.h"


@interface DSPhotoSelectionViewController () <DSDropboxAPIDelegate>

@end

@implementation DSPhotoSelectionViewController{
    AGAlertViewWithProgressbar *alertViewWithProgressbar;
}

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
    // Do any additional setup after loading the view.
    
    self.title = @"Photo Selection";
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [[DSDropboxAPI sharedInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[DSDropboxAPI sharedInstance] setDelegate:nil];
}


- (IBAction)didChooseImage:(id)sender {
    
    UIActionSheet *cameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"What image?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    cameraActionSheet.tag = 111;
    [cameraActionSheet showInView:self.view];
    
}

- (IBAction)didUploadImage:(id)sender {
    
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Upload to dropbox", @"Post in Facebook", nil];
    
    shareActionSheet.tag = 222;
    [shareActionSheet showInView:self.view];
    
}


- (void)toggleSharingAvailability{
    _btnUploadImage.enabled = !_btnUploadImage.enabled;
}


#pragma mark - UIActionSheetDelegate Methods
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 111){
        [self photoSourceActions:buttonIndex];
    }else{
        [self sharingPhotoActions:buttonIndex];
    }
    
}


- (void)photoSourceActions:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
   
    switch (buttonIndex) {
        case 0:
            //Camera Source
            //Check camera availability
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else{
                //Display camera unavailable error (only with simulator)
            }
            break;
        case 1:
            //Photo Library Source
            //Check camera availability
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

- (void)sharingPhotoActions:(NSInteger)buttonIndex{
    
    NSString *filename = _txtPhotoFilename.text;
    
    //Display error (missing name)
    if (!filename){
        
        [self missingPhotoName];
        return;
    }
    
    //else, process actionSheet
    
    switch (buttonIndex) {
        case 0:{
            //Dropbox Upload image
            [self uploadImageToDropbox:filename];
            break;
        }
        case 1:
            //Post to facebook
            break;
        default:
            break;
    }
    
}

-(void)uploadImageToDropbox:(NSString *)filename{
    
    filename = [filename stringByAppendingString:@".png"];
    
    [DSImageUtils saveImage:_photoPlaceholder.image withName:filename];
    NSString *photoPath = [DSImageUtils getRecentImagePath:filename];
    
    [self toggleSharingAvailability]; //disable "Share" avoiding multiple uploads
    
    //To-Do ability to cancel an upload
    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"Uploading Image." message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alertViewWithProgressbar show];

    [[DSDropboxAPI sharedInstance] uploadImage:filename toPath:@"/" withParentRev:nil fromPath:photoPath];
    

}

- (void)missingPhotoName{
    //UIalert with error
}


#pragma mark - UITextFieldDelegate Methods

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [_txtPhotoFilename resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtPhotoFilename resignFirstResponder];
    return NO;
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // Code here to work with media
    NSLog(@"Returned with image");
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _photoPlaceholder.image = image;
    
    if (_photoPlaceholder.image != nil) [self toggleSharingAvailability];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Returned with nothing");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - DSDropboxAPIDelegate
- (void)didUploadImage:(NSString *)destPath from:(NSString *)srcPath{
    [alertViewWithProgressbar hide];
    [self toggleSharingAvailability]; //enable share
    
    UIAlertView *success = [[UIAlertView alloc]
                                initWithTitle:@"Success!" message:@"Your photo was uploaded successfully"
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [success show];
    
}

- (void)uploadProgress:(CGFloat)progress forFile:(NSString*)destPath from:(NSString*)srcPath{
    NSLog(@"Photo Upload Progress = %f",progress);
    alertViewWithProgressbar.progress += progress;
}

- (void)uploadImageFailedWithError:(NSError *)error{
    [alertViewWithProgressbar hide];
    [self toggleSharingAvailability]; //enable share
    UIAlertView *success = [[UIAlertView alloc]
                            initWithTitle:@"Sorry..." message:@"Your photo couldn't be uploaded. Please try again"
                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [success show];
}


@end
