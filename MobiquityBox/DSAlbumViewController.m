//
//  DSAlbumViewController.m
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSAlbumViewController.h"
#import "DSPhotoThumbController.h"
#import "DSPhotoSelectionViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DSDropboxAPI.h"

@interface DSAlbumViewController () <DSDropboxAPIDelegate>

@end

@implementation DSAlbumViewController{
    UIRefreshControl *refreshControl;
    NSArray *photoPaths;
    NSString *photosHash;
    NSString *currentPhotoPath;
    BOOL working;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"Photo Album";
    
    [[DSDropboxAPI sharedInstance] setDelegate:self];
    
    //First time
    if (photoPaths == nil){
        [self fetchRemotePictures];
    }
    
    //Pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(fetchRemotePictures) forControlEvents:UIControlEventValueChanged];
    
    //Creating button for taking snapshot
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takeSnaphot)];
    self.navigationItem.rightBarButtonItem = btnCamera;
   
    
}


- (void)viewWillAppear:(BOOL)animated{
  [[DSDropboxAPI sharedInstance] setDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated {
  [[DSDropboxAPI sharedInstance] setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods
- (void)takeSnaphot{
    DSPhotoSelectionViewController *photoSelectionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSPhotoSelectionViewController"];
    
    [self.navigationController pushViewController:photoSelectionVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return photoPaths.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AlbumImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    UILabel *photoName = (UILabel *)[cell viewWithTag:200];
    photoName.text = (NSString *)[photoPaths objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Load directory and picture methods
- (void)fetchRemotePictures{
    NSString *photosRoot = @"/";
    [[DSDropboxAPI sharedInstance] loadMetadata:photosRoot withHash:photosHash];
}


#pragma mark - DSDropboxAPIDelegate
- (void)didLoadMetadata:(NSString *)currentHash withData:(NSArray *)data{
    //Added photos to the list
    photosHash = currentHash;
    photoPaths = data;
    
    [refreshControl endRefreshing]; //stop pull to refresh
    [self.tableView reloadData];    //reload data
   
}


- (void)loadMetadataFailedWithError:(NSError *)error{
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    [self displayMetadataError];
}

- (void)displayMetadataError{
    UIAlertView *alertError = [[UIAlertView alloc]
                               initWithTitle:@"Sorry..." message:@"We couldn't fetch the photos"
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertError show];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     //To-Do: Check if selected cell is a directory
     if ([[segue identifier] isEqualToString: @"LoadPhotoSegue"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         
         //Get the selected object in order to fill out the detail view
         DSPhotoThumbController *photoViewer = (DSPhotoThumbController *)[segue destinationViewController];
         [photoViewer setCurrentPhotoPath:[photoPaths objectAtIndex:indexPath.row]];
     }
}







@end
