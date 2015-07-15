//
// SAPoint.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/10.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAPoint.h"
#include <math.h>

CGPoint SAPointAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint SAPointSubtract(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint SAPointMultiply(CGPoint p, CGFloat s) {
    return CGPointMake(p.x * s, p.y * s);
}

CGPoint SAPointDivide(CGPoint p, CGFloat s) {
    return SAPointMultiply(p, 1 / s);
}

CGFloat SAPointLength(CGPoint v) {
    return sqrt(SASquare(v.x, v.y));
}

CGFloat SAPointAngle(CGPoint v) {
    return atan2(v.y, v.x);
}

CGFloat SAPointSquared(CGPoint v) {
    return SASquare(v.x, v.y);
}

CGFloat SAPointDistance(CGPoint a, CGPoint b) {
    return SAPointLength(SAPointSubtract(a, b));
}

CGPoint SAPointMid(CGPoint a, CGPoint b) {
    return SAPointMultiply(SAPointAdd(a, b), 0.5f);
}

CGPoint SAPointNormalized(CGPoint v) {
    CGFloat len = SAPointLength(v);
    return len > 0 ? SAPointDivide(v, len) : v;
}

CGPoint SAPointWithLength(CGPoint v, CGFloat length) {
    CGFloat oldlen = SAPointLength(v);
    return oldlen > 0 ? SAPointMultiply(v, length / oldlen) : v;
}

CGPoint SAPointNegative(CGPoint v) {
    return CGPointMake(-v.x, -v.y);
}

CGPoint SAPointOrthogonal(CGPoint v) {
    return CGPointMake(-v.y, v.x);
}

CGFloat SAPointDotProduct(CGPoint a, CGPoint b) {
    return a.x * b.x + a.y * b.y;
}

CGFloat SAPointCrossProduct(CGPoint a, CGPoint b) {
    return a.x * b.y - a.y * b.x;
}

CGFloat SAPointAngleTo(CGPoint a, CGPoint b) {
    return atan2(SAPointCrossProduct(a, b), SAPointDotProduct(a, b));
}

CGPoint SAPointWithAngleLength(CGFloat angle, CGFloat length) {
    return CGPointMake(length * cos(angle), length * sin(angle));
}

CGPoint SAPointWithPolar(CGPoint center, CGFloat angle, CGFloat radius) {
    return CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
}

CGPoint SAPointWithRulerX(CGPoint from, CGPoint towards, CGFloat dx) {
    CGFloat len = SAPointDistance(from, towards);
    if (len == 0) {
        return CGPointMake(from.x + dx, from.y);
    }
    CGFloat d = dx / len;
    return CGPointMake(from.x + (towards.x - from.x) * d, from.y + (towards.y - from.y) * d);
}

CGPoint SAPointWithRulerY(CGPoint from, CGPoint towards, CGFloat dy) {
    CGFloat len = SAPointDistance(from, towards);
    if (len == 0) {
        return CGPointMake(from.x, from.y + dy);
    }
    CGFloat d = dy / len;
    return CGPointMake(from.x - (towards.y - from.y) * d, from.y + (towards.x - from.x) * d);
}

CGPoint SAPointWithRuler(CGPoint from, CGPoint towards, CGFloat dx, CGFloat dy) {
    CGFloat len = SAPointDistance(from, towards);
    if (len == 0) {
        return CGPointMake(from.x + dx, from.y + dy);
    }
    CGFloat dcos = (towards.x - from.x) / len;
    CGFloat dsin = (towards.y - from.y) / len;
    return CGPointMake(from.x + dx * dcos - dy * dsin, from.y + dx * dsin + dy * dcos);
}

CGFloat SAClamp(CGFloat value, CGFloat min, CGFloat max) {
    return MAX(MIN(value, max), min);
}

CGFloat SASquare(CGFloat x, CGFloat y) {
    return x * x + y * y;
}

CGPoint SAPointClamp(CGPoint p, CGRect constrain) {
    return CGPointMake(SAClamp(p.x, CGRectGetMinX(constrain), CGRectGetMaxX(constrain)),
                       SAClamp(p.y, CGRectGetMinY(constrain), CGRectGetMaxY(constrain)));
}

CGPoint SAPointRound(CGPoint p) {
    return CGPointMake(round(p.x), round(p.y));
}

CGSize SASizeMultiply(CGSize size, CGFloat s) {
    return CGSizeMake(size.width * s, size.height * s);
}

CGSize SASizeClamp(CGSize size, CGFloat min, CGFloat max) {
    return CGSizeMake(SAClamp(size.width, min, max), SAClamp(size.height, min, max));
}

CGSize SASizeRound(CGSize size) {
    return CGSizeMake(round(size.width), round(size.height));
}

CGRect SARectMultiply(CGRect r, CGFloat s) {
    return CGRectMake(r.origin.x * s, r.origin.y * s,
                      r.size.width * s, r.size.height * s);
}

CGRect SARectRound(CGRect r) {
    return CGRectMake(round(r.origin.x), round(r.origin.y),
                      round(r.size.width), round(r.size.height));
}

CGRect SARectClamp(CGRect rect, CGRect constrain) {
    return SARectWithPoints(rect.origin, SARectCorner(rect));
}

CGPoint SARectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint SARectCorner(CGRect r) {
    return CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height);
}

CGRect SARectWithPoints(CGPoint a, CGPoint b) {
    CGFloat minx = MIN(a.x, b.x);
    CGFloat maxx = MAX(a.x, b.x);
    CGFloat miny = MIN(a.y, b.y);
    CGFloat maxy = MAX(a.y, b.y);
    return CGRectMake(minx, miny, maxx - minx, maxy - miny);
}

CGRect SARectWithCenter(CGPoint cen, CGFloat w, CGFloat h) {
    return CGRectMake(cen.x - w / 2, cen.y - h / 2, w, h);
}

CGRect SARectWithCenterSize(CGPoint cen, CGSize size) {
    return SARectWithCenter(cen, size.width, size.height);
}

CGRect SARectFromSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

BOOL SACollinear(CGPoint a, CGPoint b, CGPoint c) {
    CGFloat dist = fabs(SAPointCrossProduct(SAPointSubtract(b, a), SAPointSubtract(c, a)));
    return dist < 1e-4f;
}

BOOL SAPointIsNAN(CGPoint p) {
    return isnan(p.x) || isnan(p.y);
}

CGFloat SAAngle3P(CGPoint vertex, CGPoint a, CGPoint b) {
    return SAPointAngleTo(SAPointSubtract(a, vertex), SAPointSubtract(b, vertex));
}
