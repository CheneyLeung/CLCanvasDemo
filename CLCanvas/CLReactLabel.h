//
//  CLReactLabel.h
//  CLPinganDemo
//
//  Created by Cheney Leung on 15/7/30.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLReactLabel;

@protocol CLReactLabelDelegate <NSObject>
@optional
- (void)reactWithLabel:(CLReactLabel *)reactLabel index:(NSInteger)index;

@end


@interface CLReactLabel : UILabel
@property (strong, nonatomic) id<CLReactLabelDelegate> delegate;

@end


