//
//  ViewController.m
//  CLCanvasDemo
//
//  Created by Cheney Leung on 15/8/10.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

#import "ViewController.h"
#import "CLCanvas.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickDraw:(UIButton *)sender {
    CLCanvasViewController *canvasVC = [[CLCanvasViewController alloc]initWithSave:^(NSDictionary *imagesDic) {
        NSLog(@"save.");
    } cancel:^{
         NSLog(@"cancel.");
    }];
    [self.navigationController pushViewController:canvasVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
