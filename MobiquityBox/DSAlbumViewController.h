//
//  DSAlbumViewController.h
//  MobiquityBox
//
//  Created by Devspark on 9/3/14.
//  Copyright (c) 2014 Devspark. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DBRestClient;

@interface DSAlbumViewController : UITableViewController{
    DBRestClient *restClient;
}

@property (nonatomic,strong,readonly) DBRestClient *restClient;

@end
