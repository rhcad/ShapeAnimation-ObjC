//
//  CALayer+Pause.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+Pause.h"
#import "SAAnimationLayer.h"
#import "CAShapeLayer+Gradient.h"

@implementation CALayer (Pause)

- (BOOL)paused {
    return self.speed == 0.f;
}

- (void)setPaused:(BOOL)newValue {
    if (newValue && !self.paused) {
        CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
        self.speed = 0.f;
        self.timeOffset = pausedTime;
    }
    else if (!newValue && self.paused) {
        CFTimeInterval pausedTime = self.timeOffset;
        self.speed = 1.f;
        self.timeOffset = 0.f;
        self.beginTime = 0.f;
        self.beginTime = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    }
    if ([self isKindOfClass:[SAAnimationLayer class]]) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        ((SAAnimationLayer *)self).timer.paused = newValue;
#endif
    }
    
    self.gradientLayer.paused = newValue;
}

@end
