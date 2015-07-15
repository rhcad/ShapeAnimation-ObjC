//
//  SABezier.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/10.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAPoint.h"

BOOL    SABezierIsStraight(const CGPoint* pts);
CGFloat SABezierLength(const CGPoint* pts);
CGFloat SABeziersLength(const CGPoint* pts, int count);

void    SABezierFromQuad(CGPoint pts[4], CGPoint start, CGPoint cp, CGPoint end);
void    SABeziersFromEllipse90(CGPoint frompt, CGPoint topt, CGPoint *ctrpt1, CGPoint *ctrpt2);
void    SABeziersFromEllipse(CGPoint pts[13], CGPoint center, CGFloat rx, CGFloat ry);

CGFloat SAPathLength(CGPathRef path);

CGPathRef SAPathCreateWithBeziers(const CGPoint* pts, int count, BOOL closed);
CGPathRef SAPathCreateWithLines(const CGPoint* pts, int count, BOOL closed);
CGPathRef SAPathCreateWithRegularPolygon(int nside, CGPoint center, CGFloat radius, CGFloat startAngle);
