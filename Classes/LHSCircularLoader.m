//
//  LHSCircularLoader.m
//  LHSCircularLoader
//
//  Created by huashan on 16/7/26.
//  Copyright © 2016年 LiHuashan. All rights reserved.
//

#import "LHSCircularLoader.h"

static const CGFloat kRevealOriginalRadius = 20.0;
static const CGFloat kLineWidth = 4.0;
static const NSTimeInterval kAnimationDuration = 0.6;

@interface LHSCircularLoader () <CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LHSCircularLoader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSublayer];
    }
    return self;
}

- (void)addSublayer {
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark - 创建_shapeLayer对象的路径
- (CGPathRef)circlePathWithRadius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithArcCenter:self.center
                                          radius:radius
                                      startAngle:0
                                        endAngle:2 * M_PI
                                       clockwise:YES].CGPath;
}

#pragma mark - setter方法：展示图片的实时加载进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress > 1.0) {
        self.shapeLayer.strokeEnd = 1.0;
    }else if (progress < 0.0) {
        self.shapeLayer.strokeEnd = 0.0;
    }else {
        self.shapeLayer.strokeEnd = progress;
    }
}

- (void)reveal:(BOOL)animated {
    animated? [self performsRevealAnimation] : [self prohibitsRevealAnimation];
}

#pragma makr - 执行reveal动画
- (void)performsRevealAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self revealAnimation];
    });
}

#pragma makr - 不执行reveal动画
- (void)prohibitsRevealAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
        [_shapeLayer removeAllAnimations];
        [_shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    });
}

#pragma mark - reveal动画
- (void)revealAnimation {
    self.backgroundColor = [UIColor clearColor];
    [_shapeLayer removeAllAnimations];
    [_shapeLayer removeFromSuperlayer];
    self.superview.layer.mask = self.shapeLayer;
    
    CGFloat selfHalfWidth = self.frame.size.width*0.5;
    CGFloat selfHalfHeight = self.frame.size.height*0.5;
    CGFloat circumscribedCircleRadius = sqrt(selfHalfWidth*selfHalfWidth + selfHalfHeight*selfHalfHeight);
    CABasicAnimation *pathBasicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathBasicAnimation.toValue = (__bridge id _Nullable)([self circlePathWithRadius:circumscribedCircleRadius]);
    
    CGFloat finalLineWidth = 2 * circumscribedCircleRadius;
    CABasicAnimation *lineWidthBasicAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthBasicAnimation.toValue = @(finalLineWidth);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.animations = @[pathBasicAnimation, lineWidthBasicAnimation];
    animationGroup.duration = _revealAnimationDuration? : kAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:animationGroup forKey:@"myAnimationGroup"];
}

#pragma mark - 重置
- (void)reset {
    self.backgroundColor = [UIColor blackColor];
    [_shapeLayer removeAllAnimations];
    self.superview.layer.mask = nil;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progress = 0.0;
    [CATransaction commit];
    if (_shapeLayer) {
        [self.layer addSublayer:_shapeLayer];
    } else {
        [_shapeLayer removeFromSuperlayer];
        [self.layer addSublayer:self.shapeLayer];
    }
}

#pragma mark - setter
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.shapeLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    self.shapeLayer.lineWidth = progressWidth;
}

- (void)setRevealOriginalRadius:(CGFloat)revealOriginalRadius {
    _revealOriginalRadius = revealOriginalRadius;
    self.shapeLayer.path = [self circlePathWithRadius:revealOriginalRadius];
}

#pragma mark - 懒加载
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.lineWidth = kLineWidth;
        _shapeLayer.strokeEnd = 0.0;
        _shapeLayer.path = [self circlePathWithRadius:kRevealOriginalRadius];
    }
    return _shapeLayer;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
