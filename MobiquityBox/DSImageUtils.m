//
//  DSImageUtils.m
//  MobiquityBox
//
//  Created by Devspark on 9/5/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import "DSImageUtils.h"

@implementation DSImageUtils

#pragma mark - Temporary solution for retrieving image and paths
+ (void)saveImage: (UIImage*)image withName:(NSString *)imageFilename
{
    
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          imageFilename];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
}

+ (UIImage*)loadImage:(NSString *)imageFilename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      imageFilename];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

+ (NSString *)getRecentImagePath:(NSString *)imageFilename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      imageFilename];
    return path;
}

@end
