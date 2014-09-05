//
//  DSPhotoThumbController.h
//  MobiquityBox
//
//  Created by Devspark on 9/4/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;

@interface DSPhotoThumbController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *photoThumbImgView;
@property (nonatomic,copy) NSString *currentPhotoPath;
@property (strong, nonatomic) UIImage *thumbnail;



@end
