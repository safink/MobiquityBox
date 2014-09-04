//
//  DSPhotoSelectionViewController.m
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSPhotoSelectionViewController.h"


@interface DSPhotoSelectionViewController ()

@end

@implementation DSPhotoSelectionViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    switch (buttonIndex) {
        case 0:{
            //Dropbox upload
            [self saveImage:_photoPlaceholder.image]; //saving to temporary directory
            NSString *photoPath = [self getRecentImagePath];
            
            NSDictionary *photoMeta = [NSDictionary dictionaryWithObjects:@[@"test.png",photoPath] forKeys:@[@"filename",@"filepath"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_DROPBOX" object:self userInfo:photoMeta];
            
            break;
        }
        case 1:
            //Post to facebook
            break;
        default:
            break;
    }
    
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


#pragma mark - Temporary solution for retrieving image and paths
- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"test.png" ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];

    return image;
}

- (NSString *)getRecentImagePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    return path;
}




@end
