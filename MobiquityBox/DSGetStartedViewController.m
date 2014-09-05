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
    //self.navigationController.navigationBar.hidden = YES;

    
}


- (void)viewWillAppear:(BOOL)animated{
    _btnUnlink.enabled = [[DBSession sharedSession] isLinked];
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
    }else{
        [self goToAlbum];
    }

}

- (IBAction)unlinkAccount:(id)sender {
    [[DBSession sharedSession] unlinkAll];
    _btnUnlink.enabled = NO;
    UIAlertView *unlinkAlert = [[UIAlertView alloc]
                                initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [unlinkAlert show];
}


- (void)sessionDidAuthenticate:(NSNotification *)notification{
    NSLog(@"Session Authenticated succesfully");
    [self goToAlbum];
}

- (void)goToAlbum{
    UIViewController *albumVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSAlbumViewController"];
    [self.navigationController pushViewController:albumVC animated:YES];
}



@end
