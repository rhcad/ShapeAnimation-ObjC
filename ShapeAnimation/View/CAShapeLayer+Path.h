//
//  CAShapeLayer+Path.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/27/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAPath.h"
#import <QuartzCore/QuartzCore.h>


@interface CAShapeLayer (SAPath)

- (SAPath *)strokingPath:(CGFloat)offset;
- (SAPath *)strokingPath:(CGFloat)offset onlyOutline:(BOOL)ol;
- (SAPath *)pathToSuperlayer;
- (CGRect)strokingBounds;

- (BOOL)closed;
- (CGLineCap)cgLineCap;
- (CGLineJoin)cgLineJoin;

@end
