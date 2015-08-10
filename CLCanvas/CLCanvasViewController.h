//
//  CLCanvasViewController.h
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/29.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCanvas.h"

typedef void(^CLSaveBlock) (NSDictionary *imagesDic);
typedef void(^CLCancelBlock) ();

@interface CLCanvasViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *imagesDic;
@property (strong, nonatomic) NSMutableArray *pathsArray;
@property (strong, nonatomic) NSArray *confirmationsArray;
@property (strong, nonatomic) NSString *imageWidth;
@property (strong, nonatomic) NSString *filePath;

- (instancetype)initWithSave:(CLSaveBlock)saveBlock cancel:(CLCancelBlock)cancelBlock;

@end
