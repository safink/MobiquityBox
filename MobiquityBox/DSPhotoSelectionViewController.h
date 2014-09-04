//
//  DSPhotoSelectionViewController.h
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSPhotoSelectionViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoPlaceholder;
@property (strong, nonatomic) IBOutlet UIButton *btnUploadImage;

- (IBAction)didChooseImage:(id)sender;
- (IBAction)didUploadImage:(id)sender;

@end
