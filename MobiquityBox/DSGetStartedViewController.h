//
//  DSViewController.h
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
@protocol DSGetStartedDelegate

- (void)sessionDidAuthenticate;

@end
 */


@interface DSGetStartedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnGetStarted;


//Methods
- (IBAction)letsGetStarted:(id)sender;

@end
