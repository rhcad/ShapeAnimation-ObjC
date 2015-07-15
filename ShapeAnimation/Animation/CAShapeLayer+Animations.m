//
//  CAShapeLayer+Animations.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CAShapeLayer+Animations.h"
#import "SAAnimationDelegate.h"
#import "CAShapeLayer+Gradient.h"

@implementation CAShapeLayer (Animations)

- (SAAnimationPair *)strokeStartAnimation:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:@0];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).strokeStart = to;
        }
    }];
}

- (SAAnimationPair *)strokeStartAnimation:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).strokeStart = to;
        }
    }];
}

- (SAAnimationPair *)strokeEndAnimation {
    return [self strokeEndAnimation:0 to:1];
}

- (SAAnimationPair *)strokeEndAnimation:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:@0];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).strokeEnd = to;
        }
    }];
}

- (SAAnimationPair *)strokeEndAnimation:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).strokeEnd = to;
        }
    }];
}

- (SAAnimationPair *)strokeColorAnimation:(CGColorRef)from to:(CGColorRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    animation.fromValue = (__bridge id)from;
    animation.toValue = (__bridge id)to;
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).strokeColor = to;
        }
    }];
}

- (SAAnimationPair *)fillColorAnimation:(CGColorRef)from to:(CGColorRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)from;
    animation.toValue = (__bridge id)to;
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).fillColor = to;
        }
    }];
}

- (SAAnimationPair *)lineWidthAnimation:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            ((CAShapeLayer *)layer).lineWidth = to;
        }
    }];
}

- (SAAnimationPair *)dashPhaseAnimation {
    return [[[self dashPhaseAnimation:0 to:30] setDuration:2] forever];
}

- (SAAnimationPair *)dashPhaseAnimation:(CGFloat)from to:(CGFloat)to {
    if (!self.lineDashPattern) {
        self.lineDashPattern = @[@4, @4];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [SAAnimationPair pair:self :animation];
}

- (SAAnimationPair *)switchPathAnimation:(CGPathRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id)(to);
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            CGRect box = CGPathGetPathBoundingBox(to), frame = self.frame;
            
            layer.frame = CGRectMake(frame.origin.x, frame.origin.y, CGRectGetMaxX(box), CGRectGetMaxY(box));
            shapeLayer.path = to;
            shapeLayer.gradient = shapeLayer.gradient;
        }
    }];
}

@end
