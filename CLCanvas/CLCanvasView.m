//
//  CLCanvasView.m
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/29.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import "CLCanvasView.h"

@implementation CLCanvasView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //设置默认值
        _lineWidth = 5.0;
        _lineColor = [UIColor blackColor];
        _pointsArray = [NSMutableArray new];
        _linesArray = [NSMutableArray new];
        _wordsArray = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.clearBtn];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-44, 0, 44, 44)];
        [_clearBtn setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearContent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont boldSystemFontOfSize:28];
    }
    return _tipLabel;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineJoin(context,kCGLineJoinRound);//线条拐角样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);//线条开始样式，设置为平滑
    
    /* 画线相关代码 */
    if (_linesArray.count) {//每次重绘都会清空画面，所以要先将前面的笔画重新绘制出来
        for (NSArray *array in _linesArray) {
            [self drawLine:context points:array];
        }
    }
    [self drawLine:context points:_pointsArray];//绘制最新的画线
}

#pragma mark - Public Method

- (void)saveWordAtIndex:(NSInteger)index {
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.linesArray];
    if (index<self.wordsArray.count) {
        [self.wordsArray replaceObjectAtIndex:index withObject:array];
    }
    else {
        [self.wordsArray addObject:array];
        [self.wordsArray addObject:array];
    }
}

- (void)showWordAtIndex:(NSInteger)index {
    if (index<self.wordsArray.count)
        self.linesArray = [self.wordsArray objectAtIndex:index];
    else
        [self.linesArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)clearContent {
    [_pointsArray removeAllObjects];
    [_linesArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - Private Method

- (void)drawLine:(CGContextRef)context points:(NSArray *)paramArray {
    if (paramArray.count) {
        CGContextBeginPath(context);
        CGPoint startPoint = CGPointFromString([paramArray objectAtIndex:0]);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);//移动到起始点
        for (NSString *str in paramArray) {
            CGPoint endPoint = CGPointFromString(str);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);//与上一个点连接
        }
        CGContextStrokePath(context);
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self]; //获取手指当前位置
    [_pointsArray addObject:NSStringFromCGPoint(location)]; //将手指途经点收集
    [self setNeedsDisplay]; //通知页面重绘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_linesArray addObject:[[NSArray alloc]initWithArray:_pointsArray]];    //将上一次手指途经点收集，即为线的集合
    [_pointsArray removeAllObjects];    //清空点集合，为下一次手指途径点收集准备
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
