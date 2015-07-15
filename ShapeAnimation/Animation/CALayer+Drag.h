//
//  CALayer+Drag.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"

@interface CALayer (Drag)

- (void)constrainCenterToSuperview:(CGPoint)center;
- (void)bringOnScreen;

@end
