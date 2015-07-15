//
//  CALayer+Drag.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+Drag.h"
#import "CALayer+Animations.h"
#import "SAPoint.h"

@implementation CALayer (Drag)

- (void)constrainCenterToSuperview:(CGPoint)center {
    CGFloat kEdgeBuffer = 4;
    CGRect constrain = CGRectInset(CGRectInset(self.superlayer.bounds, kEdgeBuffer, kEdgeBuffer),
                                   self.frame.size.width / 2, self.frame.size.height / 2);
    CGPoint pt = center;
    
    if (CGRectIsEmpty(constrain)) {
        pt = SARectCenter(self.superlayer.bounds);
    } else {
        pt.x = MIN(MAX(pt.x, CGRectGetMinX(constrain)), CGRectGetMaxX(constrain));
        pt.y = MIN(MAX(pt.y, CGRectGetMinY(constrain)), CGRectGetMaxY(constrain));
    }
    [[self moveAnimation:pt] apply];
}

- (void)bringOnScreen {
    if (!CGRectContainsRect(self.superlayer.bounds, self.frame)) {
        [self constrainCenterToSuperview:self.position];
    }
}

@end
