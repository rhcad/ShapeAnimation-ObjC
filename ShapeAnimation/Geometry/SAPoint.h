//
//  SAPoint.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/10.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CGPoint SAPointAdd(CGPoint a, CGPoint b);
CGPoint SAPointSubtract(CGPoint a, CGPoint b);
CGPoint SAPointMultiply(CGPoint p, CGFloat s);
CGPoint SAPointDivide(CGPoint p, CGFloat s);

CGFloat SAPointLength(CGPoint v);
CGFloat SAPointAngle(CGPoint v);
CGFloat SAPointSquared(CGPoint v);
CGFloat SAPointDistance(CGPoint a, CGPoint b);
CGPoint SAPointMid(CGPoint a, CGPoint b);

CGPoint SAPointNormalized(CGPoint v);
CGPoint SAPointWithLength(CGPoint v, CGFloat length);
CGPoint SAPointNegative(CGPoint v);
CGPoint SAPointOrthogonal(CGPoint v);
CGFloat SAPointDotProduct(CGPoint a, CGPoint b);
CGFloat SAPointCrossProduct(CGPoint a, CGPoint b);
CGFloat SAPointAngleTo(CGPoint a, CGPoint b);

CGPoint SAPointWithAngleLength(CGFloat angle, CGFloat length);
CGPoint SAPointWithPolar(CGPoint center, CGFloat angle, CGFloat radius);
CGPoint SAPointWithRulerX(CGPoint from, CGPoint towards, CGFloat dx);
CGPoint SAPointWithRulerY(CGPoint from, CGPoint towards, CGFloat dy);
CGPoint SAPointWithRuler(CGPoint from, CGPoint towards, CGFloat dx, CGFloat dy);

CGPoint SAPointClamp(CGPoint p, CGRect constrain);
CGPoint SAPointRound(CGPoint p);
BOOL    SAPointIsNAN(CGPoint p);

CGSize  SASizeMultiply(CGSize size, CGFloat s);
CGSize  SASizeClamp(CGSize size, CGFloat min, CGFloat max);
CGSize  SASizeRound(CGSize size);

CGRect  SARectMultiply(CGRect rect, CGFloat s);
CGRect  SARectClamp(CGRect rect, CGRect constrain);
CGRect  SARectRound(CGRect rect);

CGPoint SARectCenter(CGRect rect);
CGPoint SARectCorner(CGRect rect);
CGRect  SARectWithPoints(CGPoint a, CGPoint b);
CGRect  SARectWithCenter(CGPoint cen, CGFloat w, CGFloat h);
CGRect  SARectWithCenterSize(CGPoint cen, CGSize size);
CGRect  SARectFromSize(CGSize size);

BOOL    SACollinear(CGPoint a, CGPoint b, CGPoint c);
CGFloat SAAngle3P(CGPoint vertex, CGPoint a, CGPoint b);

CGFloat SAClamp(CGFloat value, CGFloat min, CGFloat max);
CGFloat SASquare(CGFloat x, CGFloat y);
