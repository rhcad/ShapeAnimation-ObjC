//
//  CALayer+Animations.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+Animations.h"
#import "SAAnimationDelegate.h"
#import "SAPoint.h"
#import "SAPortability.h"

static void getEndInfoFunction(void *info, const CGPathElement *element);

#ifdef APPKIT_EXTERN
@implementation NSValue (CGPoint)
+ (NSValue *)valueWithCGPoint:(CGPoint)point {
    return [NSValue valueWithPoint:point];
}
- (CGPoint)CGPointValue {
    return self.pointValue;
}
@end
#endif

@implementation CALayer (Animations)

#pragma mark - opacityAnimation and flashAnimation

- (SAAnimationPair *)opacityAnimation:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:@0];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.opacity = to;
    }];
}

- (SAAnimationPair *)opacityAnimation:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(from);
    animation.toValue = @(to);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.opacity = to;
    }];
}

- (SAAnimationPair *)flashAnimation:(float)repeatCount {
    return [[[[self opacityAnimation:0 to:1] autoreverses] setRepeatCount:repeatCount] setDuration:0.2];
}

- (SAAnimationPair *)backColorAnimation:(CGColorRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.toValue = (__bridge id)to;
    [animation setDefaultProperties:self defaultFromValue:(id)self.backgroundColor];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.backgroundColor = to;
    }];
}

- (SAAnimationPair *)backColorAnimation:(CGColorRef)from to:(CGColorRef)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (__bridge id)from;
    animation.toValue = (__bridge id)to;
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.backgroundColor = to;
    }];
}

#pragma mark - scaleAnimation and tapAnimation

- (SAAnimationPair *)scaleAnimation:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CGAffineTransform oldxf = self.affineTransform;
    CGFloat oldscale = (CGFloat)hypot(oldxf.a, oldxf.b);
    
    animation.toValue = @(to * oldscale);
    [animation setDefaultProperties:self defaultFromValue:@1 timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        [layer setAffineTransform:CGAffineTransformScale(layer.affineTransform, to, to)];
    }];
}

- (SAAnimationPair *)scaleAnimation:(CGFloat)from to:(CGFloat)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CGAffineTransform oldxf = self.affineTransform;
    CGFloat oldscale = (CGFloat)hypot(oldxf.a, oldxf.b);
    
    animation.fromValue = @(from * oldscale);
    animation.toValue = @(to * oldscale);
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        [layer setAffineTransform:CGAffineTransformScale(layer.affineTransform, to, to)];
    }];
}

- (SAAnimationPair *)tapAnimation {
    CGFloat w = MAX(self.bounds.size.width, self.bounds.size.height);
    return [[self scaleAnimation:1 to:(w + 10) / w].autoreverses setDuration:0.2];
}

#pragma mark - rotate360Degrees and rotationAnimation

- (SAAnimationPair *)rotate360Degrees {
    return [self rotationAnimation:2 * M_PI];
}

- (SAAnimationPair *)rotationAnimation:(CGFloat)angle {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.additive = YES;
    animation.fromValue = @0;
    animation.toValue = @(angle);
    [animation setDefaultProperties:self defaultFromValue:nil];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        [layer setAffineTransform:CGAffineTransformRotate(layer.affineTransform, angle)];
    }];
}

#pragma mark - shakeAnimation, moveAnimation and moveOnPathAnimation

- (SAAnimationPair *)shakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.values = @[@0, @10, @-10, @10, @0];
    animation.duration = 0.8;
    animation.additive = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return [SAAnimationPair pair:self :animation key:@"shake"];
}

- (SAAnimationPair *)moveAnimation:(CGPoint)to {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:to];
    [animation setDefaultProperties:self defaultFromValue:[NSValue valueWithCGPoint:self.position]
                     timingFunction:kCAMediaTimingFunctionEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.position = to;
    }];
}

- (SAAnimationPair *)moveAnimation:(CGPoint)from to:(CGPoint)to relative:(BOOL)relative {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.additive = relative;
    animation.fromValue = [NSValue valueWithCGPoint:from];
    animation.toValue = [NSValue valueWithCGPoint:to];
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        layer.position = relative ? SAPointAdd(layer.position, to) : to;
    }];
}

- (SAAnimationPair *)moveOnPathAnimation:(CGPathRef)path {
    return [self moveOnPathAnimation:path autoRotate:NO];
}

- (SAAnimationPair *)moveOnPathAnimation:(CGPathRef)path autoRotate:(BOOL)autoRotate {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    if (autoRotate) {
        animation.rotationMode = kCAAnimationRotateAuto;
    }
    [animation setDefaultProperties:self defaultFromValue:nil timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    return [[SAAnimationPair pair:self :animation] setWillStop:^(CALayer *layer) {
        CGPoint pts[2];
        CGPathApply(path, pts, getEndInfoFunction);
        layer.position = pts[0];
        if (autoRotate) {
            CGFloat angle = SAPointAngle(SAPointSubtract(pts[0], pts[1]));
            [layer setAffineTransform:CGAffineTransformRotate(layer.affineTransform, angle)];
        }
    }];
}

@end

static void getEndInfoFunction(void *info, const CGPathElement *element) {
    CGPoint *pts = (CGPoint *)info;
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            pts[0] = element->points[0];
            break;
        case kCGPathElementAddLineToPoint:
            pts[1] = pts[0];
            pts[0] = element->points[0];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            pts[0] = element->points[1];
            pts[1] = element->points[0];
            break;
        case kCGPathElementAddCurveToPoint:
            pts[0] = element->points[2];
            pts[1] = element->points[1];
            break;
        default:
            break;
    }
}
