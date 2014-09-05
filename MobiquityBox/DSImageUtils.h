//
//  DSImageUtils.h
//  MobiquityBox
//
//  Created by Devspark on 9/5/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSImageUtils : NSObject

+ (void)saveImage: (UIImage*)image withName:(NSString *)imageFilename;
+ (UIImage*)loadImage:(NSString *)imageFilename;
+ (NSString *)getRecentImagePath:(NSString *)imageFilename;

@end
