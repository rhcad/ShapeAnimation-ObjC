//
//  SAAnimationPair.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"
#import "SAAnimationDelegate.h"
#import "CAShapeLayer+Gradient.h"
#import "CALayer+Identifier.h"

@implementation SAAnimationPair

+ (SAAnimationPair *)pair:(CALayer *)layer :(CAPropertyAnimation *)animation {
    return [SAAnimationPair pair:layer :animation key:animation.keyPath];
}

+ (SAAnimationPair *)pair:(CALayer *)layer :(CAAnimation *)animation key:(NSString *)key {
    SAAnimationPair *ret = [[SAAnimationPair alloc] init];
    ret.layer = layer;
    ret.animation = animation;
    ret.key = key;
    return ret;
}

- (SAAnimationPair *)setWillStop:(void (^)(CALayer *))block {
    __weak CALayer *wlayer = self.layer;
    __weak NSString *wkey = self.key;
    self.animation.willStop = ^(CAAnimation *anim) {
        [CAAnimation suppressAnimation:wlayer :anim key:wkey :block];
    };
    return self;
}

- (void)apply {
    if (![CAAnimation isStopping]) {
        CAGradientLayer *gradientLayer = self.layer.gradientLayer;
        if (gradientLayer) {
            CAAnimation *anim2 = self.animation.copy;
            NSString *layerid = self.layer.identifier;
            
            anim2.delegate = nil;
            if (layerid) {
                [anim2 setValue:[layerid stringByAppendingString:@"_gradient"] forKey:@"layerID"];
            }
            if ([self.key isEqualToString:@"path"]) {
                [gradientLayer.mask addAnimation:anim2 forKey:self.key];
            } else {
                [gradientLayer addAnimation:anim2 forKey:self.key];
            }
        }
        
        [self.animation setValue:self.layer.identifier forKey:@"layerID"];
        [self.layer addAnimation:self.animation forKey:self.key];
    }
}

- (void)apply:(dispatch_block_t)didStop {
    self.animation.didStop = didStop;
    [self apply];
}

- (void)applyWithDuration:(CFTimeInterval)duration {
    [[self setDuration:duration] apply];
}

- (void)applyWithDuration:(CFTimeInterval)duration didStop:(dispatch_block_t)didStop {
    [[[self setDuration:duration] setStop:didStop] apply];
}

- (SAAnimationPair *)set:(void (^)(CAAnimation *))block {
    block(self.animation);
    return self;
}

- (SAAnimationPair *)setStop:(dispatch_block_t)didStop {
    self.animation.didStop = didStop;
    return self;
}

- (SAAnimationPair *)setTimingFunction:(CAMediaTimingFunction *)function {
    self.animation.timingFunction = function;
    return self;
}

- (SAAnimationPair *)setTimingFunction:(float)c1x :(float)c1y :(float)c2x :(float)c2y {
    self.animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:c1x :c1y :c2x :c2y];
    return self;
}

- (SAAnimationPair *)setFillMode:(NSString *)fillMode {
    self.animation.fillMode = fillMode;
    if ([fillMode isEqualToString:kCAFillModeForwards]) {
        self.animation.removedOnCompletion = NO;
    }
    return self;
}

- (SAAnimationPair *)setDuration:(CFTimeInterval)duration {
    self.animation.duration = duration;
    if ([self.animation isKindOfClass:CAAnimationGroup.class]) {
        NSArray *animations = ((CAAnimationGroup *)self.animation).animations;
        for (CAAnimation *sub in animations) {
            sub.duration = duration;
        }
    }
    return self;
}

- (SAAnimationPair *)setBeginTime:(CFTimeInterval)time {
    self.animation.beginTime = CACurrentMediaTime() + time;
    return self;
}

- (SAAnimationPair *)setBeginTime:(int)index gap:(CFTimeInterval)gap {
    self.animation.beginTime = CACurrentMediaTime() + index * gap;
    return self;
}

- (SAAnimationPair *)setBeginTime:(int)index gap:(CFTimeInterval)gap duration:(CFTimeInterval)d {
    [self setDuration:d];
    self.animation.beginTime = CACurrentMediaTime() + index * gap;
    return self;
}

- (SAAnimationPair *)setRepeatCount:(float)count {
    self.animation.repeatCount = count;
    return self;
}

- (SAAnimationPair *)forever {
    self.animation.repeatCount = HUGE;
    return self;
}

- (SAAnimationPair *)autoreverses {
    self.animation.autoreverses = YES;
    return self;
}

@end
