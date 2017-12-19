//
//  JDScaleView.m
//  JDZoomView
//
//  Created by Jude on 2017/12/19.
//  Copyright © 2017年 Jude. All rights reserved.
//

#import "JDScaleView.h"
#define kSecondsHeight 6.0f

@interface JDScaleView ()
@property (nonatomic, strong) NSDictionary *attributes;
@end

@implementation JDScaleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentScale = 1;
        _secondPerPoint  = 1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    
    CGFloat linex = 0;
    NSInteger i = 0;
    while (linex < rect.size.width) {
        
        if (i % 60 == 0 || i == 0) {
            [self drawLineWithContex:ctx startPoint:CGPointMake(linex, rect.size.height) length:rect.size.height timeString:[NSString stringWithFormat:@"%ld",i / 60]];
        }
        
        if (self.currentScale < 3) {
            if (i % 10 == 0 && i % 60 != 0) {
                [self drawLineWithContex:ctx startPoint:CGPointMake(linex, rect.size.height) length:kSecondsHeight  timeString:nil];
            }
        } else if (self.currentScale < 5){
            if (i % 5 == 0 && i % 60 != 0) {
                [self drawLineWithContex:ctx startPoint:CGPointMake(linex, rect.size.height) length:kSecondsHeight timeString:nil];
            }
        } else {
            if (i % 2 == 0 && i % 60 != 0) {
                [self drawLineWithContex:ctx startPoint:CGPointMake(linex, rect.size.height) length:kSecondsHeight timeString:nil];
            }
        }
        linex +=  self.secondPerPoint * self.currentScale ; // 位置
        i ++; // 时间
    }
}

- (void)drawLineWithContex:(CGContextRef)ctx startPoint:(CGPoint)point length:(CGFloat)length timeString:(NSString *)timeString
{
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y - length);
    CGContextStrokePath(ctx);
    if (timeString) {
        [timeString drawInRect:CGRectMake(point.x + 2, point.y - length + 2, 40, 10) withAttributes:self.attributes];
    }
}

- (NSDictionary *)attributes
{
    if (_attributes == nil) {
        _attributes =  @{NSFontAttributeName : [UIFont systemFontOfSize:10],
                         NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    return _attributes;
}

- (UIColor *)strokeColor
{
    if (_strokeColor == nil) {
        _strokeColor = [UIColor whiteColor];
    }
    return _strokeColor;
}

@end
