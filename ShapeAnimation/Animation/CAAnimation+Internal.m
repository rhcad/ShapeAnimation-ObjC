//
//  CAAnimation+Internal.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationDelegate.h"
#import "CAShapeLayer+Gradient.h"

@implementation CAAnimation (Suppress)

+ (void)suppressAnimation:(dispatch_block_t)block {
    BOOL old = CATransaction.disableActions;
    CATransaction.disableActions = YES;
    block();
    CATransaction.disableActions = old;
}

@end

@implementation CAAnimation (SAInternal)

+ (void)suppressAnimation:(CALayer *)layer :(CAPropertyAnimation *)animation :(void (^)(CALayer *))block {
    [CAAnimation suppressAnimation:layer :animation key:animation.keyPath :block];
}

+ (void)suppressAnimation:(CALayer *)layer :(CAAnimation *)animation key:(NSString *)key :(void (^)(CALayer *))block {
    BOOL forwards = ([animation.fillMode isEqualToString:kCAFillModeForwards] ||
                     [animation.fillMode isEqualToString:kCAFillModeBoth]);
    CAGradientLayer *gradientLayer = layer.gradientLayer;
    
    if (!animation.autoreverses && forwards) {
        BOOL old = CATransaction.disableActions;
        CATransaction.disableActions = YES;
        block(layer);
        if (gradientLayer) {
            block(gradientLayer);
        }
        CATransaction.disableActions = old;
    }
    [layer removeAnimationForKey:key];
    [gradientLayer removeAnimationForKey:key];
}

- (void)setDefaultProperties:(CALayer *)layer defaultFromValue:(id)from {
    self.duration = 0.8;
    self.removedOnCompletion = false;
    self.fillMode = kCAFillModeForwards;
    
    if ([self isKindOfClass:CABasicAnimation.class]) {
        CABasicAnimation *basic = (CABasicAnimation *)self;
        if (basic.fromValue == nil) {
            CALayer *presentation = layer.presentationLayer;
            if (presentation) {
                basic.fromValue = [presentation valueForKeyPath:basic.keyPath];
            } else {
                basic.fromValue = from;
            }
        }
    }
}

- (void)setDefaultProperties:(CALayer *)layer defaultFromValue:(id)from timingFunction:(NSString *)name {
    [self setDefaultProperties:layer defaultFromValue:from];
    self.timingFunction = [CAMediaTimingFunction functionWithName:name];
}

@end
