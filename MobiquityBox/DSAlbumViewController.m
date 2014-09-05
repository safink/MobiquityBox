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
    
    //Creating button for taking snapshot
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takeSnaphot)];
    self.navigationItem.rightBarButtonItem = btnCamera;
    
    
}


- (void)viewWillAppear:(BOOL)animated{
//[[DSDropboxAPI sharedInstance] setDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    //[[DSDropboxAPI sharedInstance] setDelegate:nil];
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //To-Do: Check if selected cell is a directory
    DSPhotoThumbController *photoViewer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSPhotoThumbController"];
    
    [photoViewer setCurrentPhotoPath:[photoPaths objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:photoViewer animated:YES];
}


#pragma mark - Load directory and picture methods
- (void)fetchRemotePictures{
    NSString *photosRoot = @"/";
    [[DSDropboxAPI sharedInstance] loadMetadata:photosRoot withHash:photosHash];
}


#pragma mark - DSDropboxAPIDelegate
- (void)didLoadMetadata:(NSString *)currentHash withData:(NSArray *)data{
    NSLog(@"Data loaded");
    //Added photos to the list
    photosHash = currentHash;
    photoPaths = data;
    [self.tableView reloadData];
   
}
- (void)didDownloadThumbnail:(UIImage *)thumbnail inPath:(NSString *)destPath{
    UIImage *imageThumb = [UIImage imageWithContentsOfFile:destPath];
    
    DSPhotoThumbController *photoViewer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSPhotoThumbController"];
    
    [photoViewer setThumbnail:imageThumb];
    
    [self.navigationController pushViewController:photoViewer animated:YES];
}

- (void)loadMetadataFailedWithError:(NSError *)error{
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    //[self displayError];
    //[self setWorking:NO];
}








@end
