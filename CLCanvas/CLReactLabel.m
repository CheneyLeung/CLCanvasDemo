//
//  CLReactLabel.m
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/30.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import "CLReactLabel.h"

@implementation CLReactLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.highlightedTextColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark - Private Method

- (void)actWithLocation:(CGPoint)location {
    CGFloat minX = 60;
    CGFloat minY = 0;
    CGFloat wordsWidth = 45.5;
    CGFloat wordsHegiht = 32.0;
    if (CGRectContainsPoint(CGRectMake(minX, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:0];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:2];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*2, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:4];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:6];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*4, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:8];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*5, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:10];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*6+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:12];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*7+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:14];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*8+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:16];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*9+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:18];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*10+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:20];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*11+3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:22];
    }
    //进入第二行
    minX = 20;
    minY = 32;
    if (CGRectContainsPoint(CGRectMake(minX, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:22];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:24];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*2, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:26];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*3, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:28];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*4, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:30];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*5, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:32];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*6, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:34];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*7, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:36];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*8, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:38];
    }
    if (CGRectContainsPoint(CGRectMake(minX+wordsWidth*9, minY, wordsWidth, wordsHegiht), location)) {
        [self.delegate reactWithLabel:self index:40];
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self actWithLocation:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self actWithLocation:location];
//    NSLog(@"%.2f - %.2f",location.x, location.y);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

@end
