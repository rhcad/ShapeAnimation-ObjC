//
//  CALayer+Slide.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+Slide.h"
#import "SAAnimationDelegate.h"

@implementation CALayer (Slide)

// MARK: Slide animations

- (SAAnimationPair *)slideToRight {
    return [self slideAnimation:kCATransitionFromLeft];
}

- (SAAnimationPair *)slideAnimation:(NSString *)subtype {
    CATransition *slide = [CATransition animation];
    slide.type = kCATransitionPush;
    slide.subtype = subtype;
    slide.duration = 0.8;
    slide.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return [SAAnimationPair pair:self :slide key:@"slide"];
}

// MARK: Flip animations

- (SAAnimationPair *)flipHorizontally {
    return [self flipAnimationWithX:0 Y:1];
}

- (SAAnimationPair *)flipVertically {
    return [self flipAnimationWithX:1 Y:0];
}

- (SAAnimationPair *)flipAnimationWithX:(CGFloat)x Y:(CGFloat)y {
    CATransform3D xf = CATransform3DIdentity;
    xf.m34 = 1.0 / -500;
    xf = CATransform3DRotate(xf, M_PI, x, y, 0.0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.additive = YES;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:xf];
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation key:@"flip"] setWillStop:^(CALayer *layer) {
        layer.transform = CATransform3DConcat(layer.transform, xf);
    }];
}

// MARK: transform animation

- (SAAnimationPair *)transformAnimation:(CATransform3D)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:to];
    [animation setDefaultProperties:self defaultFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]
                     timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.transform = to;
    }];
}

- (SAAnimationPair *)transformAnimation:(CATransform3D)from to:(CATransform3D)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:from];
    animation.toValue = [NSValue valueWithCATransform3D:to];
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.transform = to;
    }];
}

@end
