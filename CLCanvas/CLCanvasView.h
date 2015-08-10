//
//  CLCanvasView.h
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/29.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCanvasView : UIView {
    NSMutableArray *_pointsArray;
}
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) NSMutableArray *linesArray;
@property (strong, nonatomic) NSMutableArray *wordsArray;

- (void)clearContent;
- (void)saveWordAtIndex:(NSInteger)index;
- (void)showWordAtIndex:(NSInteger)index;

@end
