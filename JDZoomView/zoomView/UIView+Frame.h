//
//  UIView+Frame.h
//  ZFDemos
//
//  Created by XiaoZefeng on 23/9/16.
//  Copyright © 2016年 肖泽峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic , assign) CGFloat zf_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic , assign) CGFloat zf_x;        ///< Shortcut for frame.origin.x.
@property (nonatomic , assign) CGFloat zf_top;         ///< Shortcut for frame.origin.y
@property (nonatomic , assign) CGFloat zf_y;         ///< Shortcut for frame.origin.y
@property (nonatomic , assign) CGFloat zf_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic , assign) CGFloat zf_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic , assign) CGFloat zf_width;       ///< Shortcut for frame.size.width.
@property (nonatomic , assign) CGFloat zf_height;      ///< Shortcut for frame.size.height.
@property (nonatomic , assign) CGFloat zf_centerX;     ///< Shortcut for center.x
@property (nonatomic , assign) CGFloat zf_centerY;     ///< Shortcut for center.y
@property (nonatomic , assign) CGPoint zf_origin;      ///< Shortcut for frame.origin.
@property (nonatomic , assign) CGSize  zf_size;        ///< Shortcut for frame.size.
+ (instancetype)viewFromXib;
/** 判断一个控件是否真正显示在主窗口 */
-(BOOL)isShowIngOnKeyWindow;

@end
