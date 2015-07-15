//
//  CALayer+AnchorPoint.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"

@interface CALayer (AnchorPoint)

- (void)setAnchorPointOnly:(CGPoint)point;
- (void)setAnchorPointOnly:(CGPoint)point fromLayer:(CALayer *)fromLayer;

@end

@interface SAAnimationPair (AnchorPoint)

- (SAAnimationPair *)setAnchorPointOnly:(CGPoint)point;
- (SAAnimationPair *)setAnchorPointOnly:(CGPoint)point fromLayer:(CALayer *)fromLayer;

@end
