//
//  JDScaleView.h
//  JDZoomView
//
//  Created by Jude on 2017/12/19.
//  Copyright © 2017年 Jude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDScaleView : UIView
@property (nonatomic, strong) UIColor *strokeColor;  
@property (nonatomic, assign) CGFloat currentScale;  //!< 当前缩放比例
@property (nonatomic, assign) CGFloat secondPerPoint; //!< 每一秒所占长度
@end
