//
//  DSViewController.h
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DSGetStartedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnGetStarted;
@property (strong, nonatomic) IBOutlet UIButton *btnUnlink;


//Methods
- (IBAction)letsGetStarted:(id)sender;
- (IBAction)unlinkAccount:(id)sender;

@end
