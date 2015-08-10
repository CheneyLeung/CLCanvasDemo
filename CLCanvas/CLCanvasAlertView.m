//
//  CLCanvasAlertView.m
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/8/3.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//
#define screenWidth     UIScreen.mainScreen.bounds.size.width
#define screenHeight    UIScreen.mainScreen.bounds.size.height
#define kAppDelegate    ((CLAppDelegate *)[[UIApplication sharedApplication]delegate])
#define kApplication    ([UIApplication sharedApplication])
#define RGBColor(r,g,b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "CLCanvasAlertView.h"
#import "CLCanvasView.h"

@implementation CLCanvasAlertView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(screenWidth/2-140, screenHeight/2-150, 280, 280)];
    if (self) {
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = RGBColor(225, 225, 225);
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.canvasView];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.okBtn];
        [self addSubview:self.alertLabel];
        
        NSString *content = [self loadConfirmation];
        _confirmationsArray = [content componentsSeparatedByString:@" "];
        _imageWidth = @"50";
        
        _overlayView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [_overlayView addSubview:self];
    }
    return self;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height/2-20, self.frame.size.width-40, 40)];
        _alertLabel.backgroundColor = [UIColor darkGrayColor];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:18.0];
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.alpha = 0.0;
        _alertLabel.text = @"未知错误";
    }
    return _alertLabel;
}

- (void)showAlertLabel:(NSString *)title {
    self.alertLabel.text = title;
    self.alertLabel.alpha = 1.0;
    [UIView animateWithDuration:2.25 animations:^{
        self.alertLabel.alpha = 0.0;
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _titleLabel.backgroundColor = RGBColor(255, 196, 68);
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (CLCanvasView *)canvasView {
    if (!_canvasView) {
        _canvasView = [[CLCanvasView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height-90)];
        _canvasView.tipLabel.hidden = YES;
    }
    return _canvasView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width/2-1, 40)];
        _cancelBtn.tag = 1000;
        _cancelBtn.backgroundColor = RGBColor(136, 130, 125);
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2+1, self.frame.size.height-40, self.frame.size.width/2-1, 40)];
        _okBtn.tag = 1001;
        [_okBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
        _okBtn.backgroundColor = RGBColor(136, 130, 125);
        [_okBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

#pragma mark - Private Method

- (NSString *)loadConfirmation {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"confirmation" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    NSLog(@"%@",content);
    return content;
}

- (UIImage *)saveScreen :(UIView *)screenView {
    self.canvasView.clearBtn.hidden = YES;
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.canvasView.clearBtn.hidden = NO;
    
    return image;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)btnAction:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    if (index==1) {
        if (self.canvasView.linesArray.count<1) {
            [self showAlertLabel:@"请先完成抄录!"];
            return;
        }
        UIImage *image = [self saveScreen:self.canvasView];
        CGSize newSize = CGSizeMake([self.imageWidth floatValue], image.size.height/image.size.width*[self.imageWidth floatValue]);
        image = [self imageWithImage:image scaledToSize:newSize];
        if (self.alertBlock) {
            self.alertBlock(image);
        }
    }
    if (self.delegate) {
        [self.delegate clickButton:self atIndex:index];
    }
    
    [self dismiss];
}

#pragma mark - Public Method

- (void)show {
    [[[[UIApplication sharedApplication]delegate]window] addSubview:_overlayView];
    CATransform3D rotate = CATransform3DMakeRotation(70.0 * M_PI / 180.0, 0.0, 0.0, 1.0);
    CATransform3D translate = CATransform3DMakeTranslation(20.0, -500.0, 0.0);
    self.layer.transform = CATransform3DConcat(rotate, translate);
    
    [UIView animateWithDuration:0.375 animations:^{
        self.layer.transform = CATransform3DIdentity;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.375 animations:^{
        CATransform3D rotate = CATransform3DMakeRotation(-70.0 * M_PI / 180.0, 0.0, 0.0, 1.0);
        CATransform3D translate = CATransform3DMakeTranslation(-20.0, 500.0, 0.0);
        self.layer.transform = CATransform3DConcat(rotate, translate);
    } completion:^(BOOL finished) {
        [_overlayView removeFromSuperview];
        self.layer.transform = CATransform3DIdentity;
    }];
}

@end
