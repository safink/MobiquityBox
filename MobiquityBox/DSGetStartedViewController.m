//
//  DSViewController.m
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSGetStartedViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DSGetStartedViewController ()

@end

@implementation DSGetStartedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionDidAuthenticate:)
                                                 name:@"SESSION_AUTHENTICATED"
                                               object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letsGetStarted:(id)sender {
    
    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
    } else {
        
        [[DBSession sharedSession] unlinkAll];
        UIAlertView *unlinkAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [unlinkAlert show];
        
//        [self updateButtons];
    }

}


- (void)sessionDidAuthenticate:(NSNotification *)notification{
    NSLog(@"Session Authenticated succesfully");
    UIViewController *albumVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSAlbumViewController"];
    [self.navigationController pushViewController:albumVC animated:YES];
    
}



@end
