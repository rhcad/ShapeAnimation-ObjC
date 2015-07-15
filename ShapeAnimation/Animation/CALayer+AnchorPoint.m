//
//  CALayer+AnchorPoint.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+AnchorPoint.h"

@implementation CALayer (AnchorPoint)

- (void)setAnchorPointOnly:(CGPoint)point {
    CGRect oldframe = self.frame;
    self.anchorPoint = point;
    self.frame = oldframe;
}

- (void)setAnchorPointOnly:(CGPoint)point fromLayer:(CALayer *)fromLayer {
    CGRect oldframe = self.frame;
    if (fromLayer) {
        CGPoint pt = [self convertPoint:point fromLayer:fromLayer];
        self.anchorPoint = CGPointMake(pt.x / self.bounds.size.width, pt.y / self.bounds.size.height);
    } else {
        self.anchorPoint = point;
    }
    self.frame = oldframe;
}

@end

@implementation SAAnimationPair (AnchorPoint)

- (SAAnimationPair *)setAnchorPointOnly:(CGPoint)point {
    [self.layer setAnchorPointOnly:point];
    return self;
}

- (SAAnimationPair *)setAnchorPointOnly:(CGPoint)point fromLayer:(CALayer *)fromLayer {
    [self.layer setAnchorPointOnly:point fromLayer:fromLayer];
    return self;
}

@end
