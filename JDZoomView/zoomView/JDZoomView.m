//
//  JDZoomView.m
//  JDZoomView
//
//  Created by Jude on 2017/12/19.
//  Copyright © 2017年 Jude. All rights reserved.
//

#import "JDZoomView.h"
#import "UIView+Frame.h"
#import "JDScaleView.h"

@interface JDZoomView()<UIScrollViewDelegate>
{
    UIScrollView *_contentView;
}
@property (nonatomic, strong) JDScaleView *scaleView;
/** 每一秒所占长度 */
@property (nonatomic, assign) NSTimeInterval secondPerPoint;
@property (nonatomic, strong) UIImageView *cursorImg;
@property (nonatomic, strong) UIView *cursorLine;
@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *cursorBgView;
@property (nonatomic, strong) UIView *volumeBubbleView;
@property (nonatomic, strong) UILabel *bubbltTitleLabel;
@property (nonatomic, assign) CGFloat currentScale;
@end

@implementation JDZoomView


- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)duration
{
    if (self = [super initWithFrame:frame]) {
        _duration = duration;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _maxScale = 5;
    _minScale = 1;
    _currentScale = 1;
    _trackColor = [UIColor purpleColor];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.trackView];
    [self.contentView addSubview:self.scaleView];
    [self.contentView addSubview:self.cursorLine];
    [self.contentView addSubview:self.cursorBgView];
    [self.contentView addSubview:self.volumeBubbleView];
    [self.cursorBgView addSubview:self.cursorImg];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.cursorBgView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] init];
    [pin addTarget:self action:@selector(pinchGesture:)];
    [self.contentView addGestureRecognizer:pin];
    [self.cursorBgView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    static CGFloat orignalFrameX;
    static CGFloat orignalOffsetX;
    
    if (![self isShowIngOnKeyWindow:self.cursorBgView]) {
        CGPoint point = CGPointMake(orignalOffsetX + (self.cursorBgView.frame.origin.x - orignalFrameX), 0);
        self.contentView.contentOffset = point;
        orignalOffsetX = point.x;
        orignalFrameX = self.cursorBgView.frame.origin.x;
    } else{
        orignalOffsetX = self.contentView.contentOffset.x;
        orignalFrameX = self.cursorBgView.frame.origin.x;
    }
}

-(BOOL)isShowIngOnKeyWindow:(UIView *)view
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect frame = view.frame;
    frame.origin.x += frame.size.width / 2 + 5;
    CGRect  newFrame = [keyWindow convertRect:frame fromView:view.superview];
    CGRect  winBounds = keyWindow.bounds;
    
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return intersects;
}

- (void)showBubbleView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.volumeBubbleView.alpha = 1;
    
    CGRect newRect = [self.cursorBgView convertRect:self.cursorBgView.frame toView:keyWindow];
    self.volumeBubbleView.frame = CGRectMake(-22.5 + newRect.origin.x, -35 + newRect.origin.y, 72, 45);
    [keyWindow addSubview:self.volumeBubbleView];
}

- (void)dismissBubbleView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.volumeBubbleView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.volumeBubbleView removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.scaleView.frame = CGRectMake(0, 0, self.frame.size.width * self.currentScale, 16);
    self.cursorBgView.center = CGPointMake(_cursorPosition * self.currentScale, 7);
    self.cursorLine.zf_left = self.cursorBgView.zf_centerX;
    self.volumeBubbleView.zf_centerX = self.cursorBgView.zf_centerX - self.contentView.contentOffset.x; // 减去scrollview的位移偏差
    self.trackView.frame = CGRectMake(0, 0, self.cursorLine.zf_left, 16);
    [self.contentView bringSubviewToFront:self.cursorLine];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.superview];
    [gesture setTranslation:CGPointZero inView:self.superview];
    _cursorPosition += point.x / self.currentScale;
    
    if (_cursorPosition < 0 || _cursorPosition > self.frame.size.width) { // 限制边上的距离
        _cursorPosition -= point.x;
        return;
    }
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(zoomView:didChangePosition:currentTime:)]) {
        [self.delegate zoomView:self didChangePosition:_cursorPosition currentTime:_cursorPosition * self.pointPerSeconds];
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self showBubbleView];
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        [self dismissBubbleView];
    } else if (gesture.state == UIGestureRecognizerStateChanged){
        
        NSInteger currentTime = self.cursorPosition * self.pointPerSeconds;
        self.bubbltTitleLabel.text = [self timeIntervalToMMSSFormat:currentTime];
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch{
    
    static CGFloat tempScale;
    static CGFloat scale;
    static CGFloat originalOffsetX;
    static CGFloat originalCenterX;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        
        tempScale = self.currentScale;
        scale = 0;
        originalOffsetX = self.contentView.contentOffset.x;
        if (pinch.numberOfTouches == 2) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:pinch.view.superview];
            CGPoint p2 = [pinch locationOfTouch:1 inView:pinch.view.superview];
            originalCenterX = (p1.x + p2.x) / 2;
        }
    } else if (pinch.state == UIGestureRecognizerStateChanged){
        
        scale = tempScale + pinch.scale - 1;
        if (scale > self.maxScale) {
            scale = self.maxScale;
        }
        if (scale < self.minScale) {
            scale = self.minScale;
        }
        self.currentScale = scale;
        self.scaleView.currentScale = scale;
        if (pinch.numberOfTouches == 2) {
            
            CGPoint p1 = [pinch locationOfTouch:0 inView:pinch.view.superview];
            CGPoint p2 = [pinch locationOfTouch:1 inView:pinch.view.superview];
            CGFloat centerX = (p1.x + p2.x) / 2;
            CGFloat offsetX = originalOffsetX +  2 * (originalCenterX - centerX); // 根据手指滑动的位置调整offset
            originalOffsetX = offsetX; // 重新赋值，调整基准
            originalCenterX = centerX;
            self.contentView.contentSize = CGSizeMake(self.frame.size.width * scale, 0);
            if (offsetX > 0) {
                [self.contentView setContentOffset:CGPointMake(offsetX, 0)];
            } else {
                [self.scaleView setNeedsDisplay];
            }
            [self setNeedsLayout];
        }
    } else if (pinch.state == UIGestureRecognizerStateEnded){
        [self.scaleView setNeedsDisplay];
    }
}

#pragma mark - 时间转化
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval / 1000000;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scaleView setNeedsDisplay];
}

#pragma mark - setter

- (void)setCurrentScale:(CGFloat)currentScale
{
    _currentScale = currentScale;
    if ([self.delegate respondsToSelector:@selector(zoomViewDidzoom:atScale:)]) {
        [self.delegate zoomViewDidzoom:self atScale: currentScale];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    self.scaleView.strokeColor = strokeColor;
}

- (void)setCursorPosition:(NSTimeInterval)cursorPosition
{
    _cursorPosition = cursorPosition;
    if ([self.delegate respondsToSelector:@selector(zoomView:didChangePosition:currentTime:)]) {
        [self.delegate zoomView:self didChangePosition:_cursorPosition currentTime: self.pointPerSeconds *  _cursorPosition];
    }
    [self setNeedsLayout];
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    self.scaleView.secondPerPoint = self.frame.size.width / duration;
    [self setNeedsDisplay];
}

#pragma mark - getter

- (NSTimeInterval)pointPerSeconds
{
    return self.duration / (NSTimeInterval)self.zf_width * 1000000;
}

- (UIView *)trackView
{
    if (!_trackView) {
        _trackView = [[UIView alloc] init];
        _trackView.backgroundColor = self.trackColor;
    }
    return _trackView;
}

- (UIView *)cursorBgView
{
    if (!_cursorBgView) {
        _cursorBgView = [[UIView alloc] init];
        _cursorBgView.backgroundColor = [UIColor clearColor];
        _cursorBgView.frame = CGRectMake(0, 0, 40, 25);
    }
    return _cursorBgView;
}

- (UIView *)cursorLine
{
    if (!_cursorLine) {
        _cursorLine = [[UIView alloc] init];
        _cursorLine.backgroundColor = [UIColor whiteColor];
        _cursorLine.frame = CGRectMake(0, 15, 1, 83 * 2);
    }
    return _cursorLine;
}

- (UIImageView *)cursorImg
{
    if (!_cursorImg) {
        _cursorImg = [[UIImageView alloc] init];
        _cursorImg.image = [UIImage imageNamed:@"rs_icon_toggle"];
        _cursorImg.userInteractionEnabled = YES;
        _cursorImg.frame = CGRectMake((self.cursorBgView.frame.size.width - 16)/2, 5, 16, 15);
    }
    return _cursorImg;
}

- (UIView *)volumeBubbleView {
    if (!_volumeBubbleView) {
        _volumeBubbleView = [[UIView alloc] init];
        _volumeBubbleView.frame = CGRectMake(-22.5, -45, 72, 45);
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rs_bg_1"]];
        UILabel *bubbltTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _volumeBubbleView.frame.size.width, 30)];
        bubbltTitleLabel.font = [UIFont systemFontOfSize:14];
        bubbltTitleLabel.textColor = [UIColor blackColor];
        bubbltTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.bubbltTitleLabel = bubbltTitleLabel;
        [_volumeBubbleView addSubview:bubbleImageView];
        [_volumeBubbleView addSubview:bubbltTitleLabel];
    }
    return _volumeBubbleView;
}


- (JDScaleView *)scaleView{
    if (_scaleView == nil) {
        _scaleView = [[JDScaleView alloc] init];
        _scaleView.secondPerPoint = self.frame.size.width / self.duration;
    }
    return _scaleView;
}

- (UIScrollView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentView.bouncesZoom = NO;
        _contentView.multipleTouchEnabled = YES;
        _contentView.alwaysBounceVertical = NO;
        _contentView.alwaysBounceHorizontal = YES;
        _contentView.delaysContentTouches  = NO;
        _contentView.canCancelContentTouches = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.directionalLockEnabled = YES;
        _contentView.delegate = self;
    }
    return _contentView;
}

- (void)dealloc{
    [self.cursorBgView removeObserver:self forKeyPath:@"center"];
}

@end
