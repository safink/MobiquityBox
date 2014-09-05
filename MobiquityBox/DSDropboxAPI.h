//
//  DSDropboxAPI.h
//  MobiquityBox
//
//  Created by Devspark on 9/5/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DSDropboxAPIDelegate <NSObject>

@optional
- (void)didLoadMetadata:(NSString *)currentHash withData:(NSArray *)data;
- (void)didDownloadThumbnail:(UIImage *)thumbnail inPath:(NSString *)destPath;
- (void)didUploadImage:(NSString *)destPath from:(NSString *)srcPath;
- (void)uploadProgress:(CGFloat)progress forFile:(NSString*)destPath from:(NSString*)srcPath;
- (void)loadMetadataFailedWithError:(NSError *)error;
- (void)loadThumbnailFailedWithError:(NSError *)error;
- (void)uploadImageFailedWithError:(NSError *)error;


@end

@interface DSDropboxAPI : NSObject{
    NSString *relinkUserId;
    DBRestClient *restClient;
}

//Singleton method
+ (DSDropboxAPI *)sharedInstance;

#pragma mark - DropboxAPI Properties
@property (nonatomic,strong,readonly) DBRestClient *restClient;
@property (nonatomic,strong) UIViewController<DSDropboxAPIDelegate> *delegate;


#pragma mark - DropboxAPI Methods
//Load metadata (fetch directory)
- (void)loadMetadata:(NSString *)metadata withHash:(NSString *)hash;

//Upload image
- (void)uploadImage:(NSString *)imgName toPath:(NSString *)destDir withParentRev:(NSString *)parentRev fromPath:(NSString *)imgPath;

//Download image
- (void)loadThumbnail:(NSString *)path ofSize:(NSString *)size intoPath:(NSString *)destinationPath;


@end
