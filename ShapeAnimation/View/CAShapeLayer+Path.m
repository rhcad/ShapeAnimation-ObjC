//
//  CAShapeLayer+Path.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/27/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CAShapeLayer+Path.h"

static void checkClosedFunction(void *info, const CGPathElement *element);
static void createSubpaths(void *info, const CGPathElement *element);

@implementation CAShapeLayer (SAPath)

- (SAPath *)strokingPath:(CGFloat)offset {
    return [self strokingPath:offset onlyOutline:NO];
}

- (CGRect)strokingBounds {
    return CGRectInset(CGPathGetPathBoundingBox(self.path), -self.lineWidth / 2, -self.lineWidth / 2);
}

- (SAPath *)strokingPath:(CGFloat)offset onlyOutline:(BOOL)ol {
    if (self.path == nil) {
        return nil;
    }
    CGPathRef ret = CGPathCreateCopyByStrokingPath(self.path, nil, 2 * offset + self.lineWidth,
                                                   self.cgLineCap, self.cgLineJoin, self.miterLimit);
    if (self.closed) {
        CGMutablePathRef paths[] = { nil, nil };
        
        CGPathApply(ret, paths, createSubpaths);
        CGPathRelease(ret);
        if (CGRectContainsRect(CGPathGetBoundingBox(paths[0]), CGPathGetBoundingBox(paths[1]))) {
            ret = paths[0];
            CGPathRelease(paths[1]);
        } else {
            ret = paths[1];
            CGPathRelease(paths[0]);
        }
    }
    
    return [SAPath pathWithCGPath:ret];
}

- (SAPath *)pathToSuperlayer {
    CGPoint pt = self.frame.origin;
    CGAffineTransform xf = CGAffineTransformTranslate(self.affineTransform, pt.x, pt.y);
    return self.path ? [SAPath pathWithCGPath:CGPathCreateCopyByTransformingPath(self.path, &xf)] : nil;
}

- (CGLineCap)cgLineCap {
    if ([self.lineCap isEqualToString:kCALineCapButt])
        return kCGLineCapButt;
    if ([self.lineCap isEqualToString:kCALineCapSquare])
        return kCGLineCapSquare;
    return kCGLineCapRound;
}

- (CGLineJoin)cgLineJoin {
    if ([self.lineJoin isEqualToString:kCALineJoinMiter])
        return kCGLineJoinMiter;
    if ([self.lineJoin isEqualToString:kCALineJoinBevel])
        return kCGLineJoinBevel;
    return kCGLineJoinRound;
}

- (BOOL)closed {
    BOOL ret = NO;
    CGPathApply(self.path, &ret, checkClosedFunction);
    return ret;
}

@end

static void checkClosedFunction(void *info, const CGPathElement *element) {
    if (element->type == kCGPathElementCloseSubpath) {
        *((BOOL *)info) = YES;
    }
}

static void createSubpaths(void *info, const CGPathElement *element) {
    CGMutablePathRef *paths = (CGMutablePathRef *)info;
    CGMutablePathRef path = paths[paths[1] ? 1 : 0];
    
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            if (!paths[1]) {
                path = CGPathCreateMutable();
                paths[paths[0] ? 1 : 0] = path;
                CGPathMoveToPoint(path, nil, element->points[0].x, element->points[0].y);
            }
            break;
        case kCGPathElementAddLineToPoint:
            CGPathAddLineToPoint(path, nil, element->points[0].x, element->points[0].y);
            break;
        case kCGPathElementAddQuadCurveToPoint:
            CGPathAddQuadCurveToPoint(path, nil, element->points[0].x, element->points[0].y,
                                      element->points[1].x, element->points[1].y);
            break;
        case kCGPathElementAddCurveToPoint:
            CGPathAddCurveToPoint(path, nil, element->points[0].x, element->points[0].y, element->points[1].x,
                                  element->points[1].y, element->points[2].x, element->points[2].y);
            break;
        case kCGPathElementCloseSubpath:
            CGPathCloseSubpath(path);
        default:
            break;
    }
}
