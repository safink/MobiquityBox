//
//  DSPhotoThumbController.m
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSPhotoThumbController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DSPhotoThumbController ()

@end

@implementation DSPhotoThumbController

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
    
    self.photoThumbImgView.image = self.thumbnail;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
