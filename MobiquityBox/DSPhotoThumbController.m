//
//  DSPhotoThumbController.m
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSPhotoThumbController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DSDropboxAPI.h"

@interface DSPhotoThumbController ()<DSDropboxAPIDelegate>

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
    
    //self.photoThumbImgView.image = self.thumbnail;
    [[DSDropboxAPI sharedInstance] setDelegate:self];
    [self loadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadImage{
    [[DSDropboxAPI sharedInstance] loadThumbnail:_currentPhotoPath ofSize:@"iphone_bestfit" intoPath:[self photoPath]];
}

//Temporary path where to put remote photo
- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}



#pragma mark - DSDropboxAPIDelegate Methods
- (void)didDownloadThumbnail:(UIImage *)thumbnail inPath:(NSString *)destPath{
    self.thumbnail = [UIImage imageWithContentsOfFile:destPath];
    self.photoThumbImgView.image = self.thumbnail;
}

- (void)loadThumbnailFailedWithError:(NSError *)error{
    //[self setWorking:NO];
    //[self displayError];
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
