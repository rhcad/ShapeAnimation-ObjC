//
//  CALayer+Animations.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"

@interface CALayer (Animations)

- (SAAnimationPair *)opacityAnimation:(CGFloat)to;
- (SAAnimationPair *)opacityAnimation:(CGFloat)from to:(CGFloat)to;
- (SAAnimationPair *)flashAnimation:(float)repeatCount;

- (SAAnimationPair *)backColorAnimation:(CGColorRef)to;
- (SAAnimationPair *)backColorAnimation:(CGColorRef)from to:(CGColorRef)to;

- (SAAnimationPair *)scaleAnimation:(CGFloat)to;
- (SAAnimationPair *)scaleAnimation:(CGFloat)from to:(CGFloat)to;
- (SAAnimationPair *)tapAnimation;

- (SAAnimationPair *)rotate360Degrees;
- (SAAnimationPair *)rotationAnimation:(CGFloat)angle;

- (SAAnimationPair *)shakeAnimation;
- (SAAnimationPair *)moveAnimation:(CGPoint)to;
- (SAAnimationPair *)moveAnimation:(CGPoint)from to:(CGPoint)to relative:(BOOL)relative;
- (SAAnimationPair *)moveOnPathAnimation:(CGPathRef)path;
- (SAAnimationPair *)moveOnPathAnimation:(CGPathRef)path autoRotate:(BOOL)autoRotate;

@end
