//
//  ViewController.m
//  JDZoomView
//
//  Created by Jude on 2017/12/19.
//  Copyright © 2017年 Jude. All rights reserved.
//

#import "ViewController.h"
#import "JDZoomView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+Frame.h"

@interface ViewController ()<JDZoomViewDelegate>
@property (nonatomic, weak) UIView *subView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_interactivePopDisabled = YES;
    
    JDZoomView *zooomView = [[JDZoomView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300) duration:265];
    zooomView.backgroundColor = [UIColor lightGrayColor];
    zooomView.delegate = self;
    [self.view addSubview:zooomView];
    
    UIView *subView = [[UIView alloc] init];
    subView.frame = CGRectMake(50, 50, 100, 30);
    subView.backgroundColor = [UIColor yellowColor];
    [zooomView.contentView addSubview:subView];
    self.subView = subView;
}
    
#pragma mark - JDZoomViewDelegate

- (void)zoomView:(JDZoomView *)zoomView didChangePosition:(CGFloat)position currentTime:(NSTimeInterval)time{
    
}
- (void)zoomViewDidzoom:(JDZoomView *)zoomView atScale:(CGFloat)scale{
    NSLog(@"scale = %f",scale);
    self.subView.frame = CGRectMake(50 * scale, 50, 100 * scale, 30);
}

@end
