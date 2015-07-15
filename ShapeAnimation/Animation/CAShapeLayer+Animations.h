//
//  CAShapeLayer+Animations.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"

@interface CAShapeLayer (Animations)

- (SAAnimationPair *)strokeStartAnimation:(CGFloat)to;
- (SAAnimationPair *)strokeStartAnimation:(CGFloat)from to:(CGFloat)to;

- (SAAnimationPair *)strokeEndAnimation;
- (SAAnimationPair *)strokeEndAnimation:(CGFloat)to;
- (SAAnimationPair *)strokeEndAnimation:(CGFloat)from to:(CGFloat)to;

- (SAAnimationPair *)strokeColorAnimation:(CGColorRef)from to:(CGColorRef)to;
- (SAAnimationPair *)fillColorAnimation:(CGColorRef)from to:(CGColorRef)to;
- (SAAnimationPair *)lineWidthAnimation:(CGFloat)from to:(CGFloat)to;
- (SAAnimationPair *)dashPhaseAnimation;
- (SAAnimationPair *)dashPhaseAnimation:(CGFloat)from to:(CGFloat)to;
- (SAAnimationPair *)switchPathAnimation:(CGPathRef)to;

@end
