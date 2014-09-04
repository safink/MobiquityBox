//
//  DSAlbumViewController.m
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSAlbumViewController.h"
#import "DSPhotoThumbController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DSAlbumViewController () <DBRestClientDelegate>

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (photoPaths == nil){
        [self fetchRemotePictures];
    }
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    restClient = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    currentPhotoPath = [photoPaths objectAtIndex:indexPath.row];
    [self.restClient loadThumbnail:currentPhotoPath ofSize:@"iphone_bestfit" intoPath:[self photoPath]];
    
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


#pragma mark - Load directory and picture methods
- (void)fetchRemotePictures{
    NSString *photosRoot = @"/";
    [self.restClient loadMetadata:photosRoot withHash:photosHash];
}

//Temporary path where to put
- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}


#pragma mark - DBRestClient getter

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}



#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {

    photosHash = metadata.hash;
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }

    //Added photos to the list
    photoPaths = newPhotoPaths;
    [self.tableView reloadData];
//    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    //[self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    //[self displayError];
    //[self setWorking:NO];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    
    UIImage *imageThumb = [UIImage imageWithContentsOfFile:destPath];
    
    DSPhotoThumbController *photoViewer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DSPhotoThumbController"];
    
    [photoViewer setThumbnail:imageThumb];
    
    [self.navigationController pushViewController:photoViewer animated:YES];
    
    //[self setWorking:NO];
    //imageView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    //[self setWorking:NO];
    //[self displayError];
}





@end
