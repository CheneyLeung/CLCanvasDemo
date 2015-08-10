//
//  CLCanvasViewController.m
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/29.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#define screenWidth     UIScreen.mainScreen.bounds.size.width
#define screenHeight    UIScreen.mainScreen.bounds.size.height
#define kAppDelegate    ((CLAppDelegate *)[[UIApplication sharedApplication]delegate])
#define kApplication    ([UIApplication sharedApplication])
#define RGBColor(r,g,b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "CLCanvasViewController.h"
#import "CLReactLabel.h"

@interface CLCanvasViewController ()<CLReactLabelDelegate> {
    UIButton *_lastPageBtn;
    UIButton *_nextPageBtn;
    UIButton *_cancelBtn;
    UIButton *_saveBtn;
    
    CLSaveBlock _saveBlock;
    CLCancelBlock _cancelBlock;
    NSInteger _currentIndex;
}
@property (strong, nonatomic) UIView *btnBar;
@property (strong, nonatomic) CLCanvasView *drawViewLeft;
@property (strong, nonatomic) CLCanvasView *drawViewRight;
@property (strong, nonatomic) CLReactLabel *reactLabel;
@property (strong, nonatomic) UILabel *alertLabel;

@end

@implementation CLCanvasViewController

- (instancetype)initWithSave:(CLSaveBlock)saveBlock cancel:(CLCancelBlock)cancelBlock {
    if (self = [super init]) {
        _saveBlock = saveBlock;
        _cancelBlock = cancelBlock;
        _currentIndex = 0;
        _imagesDic = [NSMutableDictionary new];
        _pathsArray = [NSMutableArray new];
        _imageWidth = @"50";
        NSString *content = [self loadConfirmation];
        _confirmationsArray = [content componentsSeparatedByString:@" "];
        self.drawViewLeft.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex];
        self.drawViewRight.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex+1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.reactLabel];
    [self.view addSubview:self.drawViewLeft];
    [self.view addSubview:self.drawViewRight];
    [self.view addSubview:self.btnBar];
    [self.view addSubview:self.alertLabel];
    
    self.view.backgroundColor = RGBColor(238, 238, 238);
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [kApplication setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [kApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (CLCanvasView *)drawViewLeft {
    if (!_drawViewLeft) {
        _drawViewLeft = [[CLCanvasView alloc]initWithFrame:CGRectMake(0, 69, screenHeight/2-1, screenWidth-64-10-49)];
    }
    return _drawViewLeft;
}

- (CLCanvasView *)drawViewRight {
    if (!_drawViewRight) {
        _drawViewRight = [[CLCanvasView alloc]initWithFrame:CGRectMake(screenHeight/2+1, 69, screenHeight/2-1, screenWidth-64-10-49)];
    }
    return _drawViewRight;
}

- (CLReactLabel *)reactLabel {
    if (!_reactLabel) {
        _reactLabel = [[CLReactLabel alloc]initWithFrame:CGRectMake(0, 0, screenHeight, 64)];
        _reactLabel.delegate = self;
        _reactLabel.backgroundColor = RGBColor(255, 196, 68);
        _reactLabel.numberOfLines = 0;
        _reactLabel.font = [UIFont boldSystemFontOfSize:18];
        _reactLabel.textColor = [UIColor whiteColor];
        
        // NSMutableParagraphStyle
        NSString *content = [self loadConfirmation];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:content];
        NSMutableParagraphStyle *paraSty = [[NSMutableParagraphStyle alloc]init];
        paraSty.lineSpacing = 5.0;
        paraSty.firstLineHeadIndent = 60.0;
        paraSty.headIndent = 20.0;
        paraSty.tailIndent = screenHeight-5.0;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paraSty range:NSMakeRange(0, content.length)];
        _reactLabel.attributedText = attrString;
    }
    return _reactLabel;
}

- (UIView *)btnBar {
    if (!_btnBar) {
        _btnBar = [[UIView alloc]initWithFrame:CGRectMake(0, screenWidth-49, screenHeight, 49)];
        _btnBar.backgroundColor = RGBColor(136, 130, 125);
        
        // Button
        CGFloat kPaddingBtn = 40 + 60;
        CGFloat maxX = screenHeight/2-180;
        _lastPageBtn = [[UIButton alloc]initWithFrame:CGRectMake(maxX, 0, 60, 46)];
        [_lastPageBtn setImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
        [_lastPageBtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBar addSubview:_lastPageBtn];
        
        maxX += kPaddingBtn;
        _nextPageBtn = [[UIButton alloc]initWithFrame:CGRectMake(maxX, 0, 60, 46)];
        [_nextPageBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_nextPageBtn addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBar addSubview:_nextPageBtn];
        
        maxX += kPaddingBtn;
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(maxX, 0, 60, 46)];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBar addSubview:_cancelBtn];
        
        maxX += kPaddingBtn;
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(maxX, 0, 60, 46)];
        [_saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBar addSubview:_saveBtn];
    }
    return _btnBar;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, screenWidth/2-20, screenHeight-250, 40)];
        _alertLabel.backgroundColor = [UIColor darkGrayColor];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:18.0];
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.alpha = 0.0;
        _alertLabel.text = @"未知错误";
    }
    return _alertLabel;
}

- (NSString *)filePath {
    if (!_filePath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        _filePath = [documentPath stringByAppendingPathComponent:@"confirmation"];
        NSLog(@"imagePath: %@",_filePath);
        
        if (![fileManager fileExistsAtPath:_filePath]) {
            if (![fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"Create directory fail.");
                _filePath = documentPath;
            }
        }
    }
    return _filePath;
}

#pragma mark - Private Method

- (void)showAlertLabel:(NSString *)title {
    self.alertLabel.text = title;
    self.alertLabel.alpha = 1.0;
    [UIView animateWithDuration:2.25 animations:^{
        self.alertLabel.alpha = 0.0;
    }];
}

- (NSString *)loadConfirmation {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"confirmation" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    NSLog(@"%@",content);
    return content;
}

- (UIImage *)saveScreen :(UIView *)screenView {
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    image = [CLDrawSignView imageToTransparent:image]; //仍未明确其作用
    return image;
}

//颜色替换
+ (UIImage*)imageToTransparent:(UIImage*)image {
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t    bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        //把绿色变成黑色，把背景色变成透明
        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

/* 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}

- (void)writeImageToFile:(UIImage *)image index:(NSInteger)index {
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *path = [NSString stringWithFormat:@"%@/image%ld.png",self.filePath,index];
    [self.pathsArray addObject:path];
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

- (void)saveImage {
    self.drawViewLeft.tipLabel.hidden = YES;
    self.drawViewLeft.clearBtn.hidden = YES;
    self.drawViewRight.tipLabel.hidden = YES;
    self.drawViewRight.clearBtn.hidden = YES;
    
    UIImage *image1 = [self saveScreen:self.drawViewLeft];
    UIImage *image2 = [self saveScreen:self.drawViewRight];
    CGSize newSize = CGSizeMake([self.imageWidth floatValue], image1.size.height/image1.size.width*[self.imageWidth floatValue]);
    image1 = [self imageWithImage:image1 scaledToSize:newSize];
    image2 = [self imageWithImage:image2 scaledToSize:newSize];
    //    NSLog(@"%ld - %ld",self.imagesArray.count-1,_currentIndex);
    [self.imagesDic setValue:image1 forKey:[NSString stringWithFormat:@"%ld",_currentIndex]];
    [self.imagesDic setValue:image2 forKey:[NSString stringWithFormat:@"%ld",_currentIndex+1]];
    
    [self writeImageToFile:image1 index:_currentIndex];
    [self writeImageToFile:image2 index:_currentIndex+1];
    
    [self.drawViewLeft saveWordAtIndex:_currentIndex];
    [self.drawViewRight saveWordAtIndex:_currentIndex+1];
    
    self.drawViewLeft.tipLabel.hidden = NO;
    self.drawViewLeft.clearBtn.hidden = NO;
    self.drawViewRight.tipLabel.hidden = NO;
    self.drawViewRight.clearBtn.hidden = NO;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)changeConfirmationColor:(NSUInteger)leungth {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.reactLabel.attributedText];
    if (leungth>attrString.length) {
        leungth = attrString.length;
    }
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, leungth)];
    self.reactLabel.attributedText = attrString;
}

- (void)btnAction:(UIButton *)sender {
    if (sender==_saveBtn) {
        [self saveImage];
        if (self.imagesDic.count<self.confirmationsArray.count) {
            [self showAlertLabel:@"请先完成抄录！"];
            return;
        }
        if (self.imagesDic.count>self.confirmationsArray.count) {
            [self.imagesDic removeObjectForKey:[NSString stringWithFormat:@"%ld",self.confirmationsArray.count]];
        }
        if (_saveBlock) {
            _saveBlock(self.imagesDic);
        }
    }
    else if (sender==_cancelBtn) {
        if (_cancelBlock) {
            _cancelBlock();
        }
    }
    if (self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pageAction:(UIButton *)sender {
    if (sender==_nextPageBtn) {
        if (_currentIndex>_confirmationsArray.count-3) {
            [self showAlertLabel:@"已经是最后一页！"];
            return;
        }
        if (self.drawViewLeft.linesArray.count<1 || self.drawViewRight.linesArray.count<1) {
            [self showAlertLabel:@"请先完成该页抄录！"];
            return;
        }
        [self saveImage];
        _currentIndex+=2;
    }
    else if (sender==_lastPageBtn) {
        if (_currentIndex==0) {
            [self showAlertLabel:@"已经是第一页！"];
            return;
        }
        if (self.drawViewLeft.linesArray.count<1 || self.drawViewRight.linesArray.count<1) {
            [self showAlertLabel:@"请先完成该页抄录！"];
            return;
        }
        [self saveImage];
        _currentIndex-=2;
    }
    
    [self changeConfirmationColor:(self.imagesDic.count*2-1)];
    self.drawViewLeft.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex];
    if (_currentIndex+1<_confirmationsArray.count)
        self.drawViewRight.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex+1];
    else
        self.drawViewRight.tipLabel.text = @" ";
    
    [self.drawViewLeft clearContent];
    [self.drawViewRight clearContent];
    [self.drawViewLeft showWordAtIndex:_currentIndex];
    [self.drawViewRight showWordAtIndex:_currentIndex+1];
}

#pragma mark - CLReactLabelDelegate

- (void)reactWithLabel:(CLReactLabel *)reactLabel index:(NSInteger)index {
    if (index<self.imagesDic.count) {
        _currentIndex = index;
        self.drawViewLeft.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex];
        if (_currentIndex+1<_confirmationsArray.count)
            self.drawViewRight.tipLabel.text = [_confirmationsArray objectAtIndex:_currentIndex+1];
        else
            self.drawViewRight.tipLabel.text = @" ";
        
        [self.drawViewLeft showWordAtIndex:_currentIndex];
        [self.drawViewRight showWordAtIndex:_currentIndex+1];
    }
}

@end
