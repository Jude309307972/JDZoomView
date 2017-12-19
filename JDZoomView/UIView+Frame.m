//
//  UIView+Frame.m
//  ZFDemos
//
//  Created by XiaoZefeng on 23/9/16.
//  Copyright © 2016年 肖泽峰. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)zf_left
{
    return self.frame.origin.x;
}

- (void)setZf_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)zf_x {
    return [self zf_left];
}

- (void)setZf_x:(CGFloat)x {
    [self setZf_left:x];
}

- (CGFloat)zf_top
{
    return self.frame.origin.y;
}

- (void)setZf_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)zf_y {
    return [self zf_top];
}

- (void)setZf_y:(CGFloat)y {
    [self setZf_top:y];
}


- (CGFloat)zf_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZf_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)zf_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setZf_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)zf_width
{
    return self.frame.size.width;
}

- (void)setZf_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)zf_height
{
    return self.frame.size.height;
}

- (void)setZf_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)zf_centerX
{
    return self.center.x;
}

- (void)setZf_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)zf_centerY
{
    return self.center.y;
}

- (void)setZf_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)zf_origin
{
    return self.frame.origin;
}

- (void)setZf_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)zf_size
{
    return self.frame.size;
}

- (void)setZf_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(BOOL)isShowIngOnKeyWindow
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect  newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect  winBounds = keyWindow.bounds;
    
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

@end
