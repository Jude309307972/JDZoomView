//
//  JDZoomView.h
//  JDZoomView
//
//  Created by Jude on 2017/12/19.
//  Copyright © 2017年 Jude. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDZoomView;
@protocol JDZoomViewDelegate<NSObject>
@optional
- (void)zoomView:(JDZoomView *)zoomView didChangePosition:(CGFloat)position currentTime:(NSTimeInterval)time;
- (void)zoomViewDidzoom:(JDZoomView *)zoomView atScale:(CGFloat)scale;
@end

@interface JDZoomView : UIView
- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)duration;//!< 传入时间已s为单位
@property (nonatomic, weak) id<JDZoomViewDelegate> delegate;
@property (nonatomic, strong) UIColor *strokeColor; //!< 绘制刻度线条的颜色
@property (nonatomic, strong) UIColor *trackColor; //!< 录制过的路径颜色
@property (nonatomic, assign) NSTimeInterval cursorPosition; //!< 光标中点
@property (nonatomic, assign) NSTimeInterval duration; //!< 时长
@property (nonatomic, assign) NSTimeInterval pointPerSeconds; //!< 每个点代表的秒数
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, strong, readonly) UIScrollView *contentView; //!< 需同步缩放的子控件添加到contentView
@end

