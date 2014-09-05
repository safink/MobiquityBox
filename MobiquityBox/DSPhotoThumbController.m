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

@implementation DSPhotoThumbController{
    BOOL working;
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
    [[DSDropboxAPI sharedInstance] setDelegate:self];
    _activityIndicator.hidesWhenStopped = YES;
    [self loadImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [[DSDropboxAPI sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadImage{
    [self setWorking:YES];
    [[DSDropboxAPI sharedInstance] loadThumbnail:_currentPhotoPath ofSize:@"iphone_bestfit" intoPath:[self photoPath]];
}

//Temporary path where to put remote photo
- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}



#pragma mark - DSDropboxAPIDelegate Methods
- (void)didDownloadThumbnail:(UIImage *)thumbnail inPath:(NSString *)destPath{
    [self setWorking:NO];
    self.thumbnail = [UIImage imageWithContentsOfFile:destPath];
    self.photoThumbImgView.image = self.thumbnail;
}

- (void)loadThumbnailFailedWithError:(NSError *)error{
    [self setWorking:NO];
    //[self displayError];
}

- (void)setWorking:(BOOL)isWorking {
    if (working == isWorking) return;
    working = isWorking;
    
    if (working) {
        [_activityIndicator startAnimating];
    } else {
        [_activityIndicator stopAnimating];
    }
}



@end
