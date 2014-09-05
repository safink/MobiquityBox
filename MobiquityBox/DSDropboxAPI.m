//
//  DSDropboxAPI.m
//  MobiquityBox
//
//  Created by Devspark on 9/5/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSDropboxAPI.h"

@interface DSDropboxAPI () <DBRestClientDelegate>

@end

@implementation DSDropboxAPI


- (id)init {
    if (self = [super init]) {
        //Custom first time initialization
    }
    return self;
}


+ (DSDropboxAPI *)sharedInstance{
    static DSDropboxAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DSDropboxAPI alloc] init];
    });
    
    return _sharedInstance;
}


- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

#pragma mark - DropboxAPI Methods
//Load metadata (fetch directory)
- (void)loadMetadata:(NSString *)metadata withHash:(NSString *)hash{
//    if (!metadata || !hash) return;
    [self.restClient loadMetadata:metadata withHash:hash];
}

//Upload image
- (void)uploadImage:(NSString *)imgName toPath:(NSString *)destDir withParentRev:(NSString *)parentRev fromPath:(NSString *)imgPath{
    [self.restClient uploadFile:imgName toPath:destDir withParentRev:parentRev fromPath:imgPath];
}

//Download image
- (void)loadThumbnail:(NSString *)path ofSize:(NSString *)size intoPath:(NSString *)destinationPath{
    [self.restClient loadThumbnail:path ofSize:size intoPath:destinationPath];
}



#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    
    NSString *photosHash = metadata.hash;
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }
    
    //Added photos to the list
    NSArray *photoPaths = newPhotoPaths;
    
    //Calling delegate passing required attributes
    [_delegate didLoadMetadata:photosHash withData:photoPaths];

}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {

}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {    
    [_delegate loadMetadataFailedWithError:error];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    UIImage *imageThumb = [UIImage imageWithContentsOfFile:destPath];
    [_delegate didDownloadThumbnail:imageThumb inPath:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    [_delegate loadThumbnailFailedWithError:error];
}


- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath
          metadata:(DBMetadata*)metadata{
    [_delegate didUploadImage:destPath from:srcPath];
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
           forFile:(NSString*)destPath from:(NSString*)srcPath{
    [_delegate uploadProgress:progress forFile:destPath from:srcPath];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error{
    [_delegate uploadImageFailedWithError:error];
}




@end
