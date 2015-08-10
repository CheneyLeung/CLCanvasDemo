//
//  CLCanvasAlertView.h
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/8/3.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLCanvasView;
@class CLCanvasAlertView;
typedef void(^CLAlertBlock) (UIImage *image);

@protocol CLCanvasAlertDelegate <NSObject>
@optional
- (void)clickButton:(CLCanvasAlertView *)alertView atIndex:(NSInteger)index;

@end

@interface CLCanvasAlertView : UIView {
    UIView *_overlayView;
}
@property (strong, nonatomic) id<CLCanvasAlertDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *okBtn;
@property (strong, nonatomic) CLCanvasView *canvasView;
@property (strong, nonatomic) NSArray *confirmationsArray;
@property (strong, nonatomic) UILabel *alertLabel;
@property (copy, nonatomic) CLAlertBlock alertBlock;
@property (strong, nonatomic) NSString *imageWidth;

- (void)show;
- (void)dismiss;

@end
