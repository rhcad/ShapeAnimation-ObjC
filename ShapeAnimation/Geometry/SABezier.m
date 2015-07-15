//
//  SABezier.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/10.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SABezier.h"

BOOL SABezierIsStraight(const CGPoint* pts) {
    return SACollinear(pts[0], pts[3], pts[1]) || SACollinear(pts[0], pts[3], pts[2]);
}

static CGFloat base3(CGFloat t, CGFloat p1, CGFloat p2, CGFloat p3, CGFloat p4) {
    CGFloat t1 = -3*p1 + 9*p2 - 9*p3 + 3*p4;
    CGFloat t2 = t*t1 + 6*p1 - 12*p2 + 6*p3;
    return t*t2 - 3*p1 + 3*p2;
}

static CGFloat cubicF(CGFloat t, const CGPoint *pts) {
    CGFloat xbase = base3(t, pts[0].x, pts[1].x, pts[2].x, pts[3].x);
    CGFloat ybase = base3(t, pts[0].y, pts[1].y, pts[2].y, pts[3].y);
    return hypot(xbase, ybase);
}

CGFloat SABezierLength(const CGPoint* pts) {
    // Legendre-Gauss abscissae (xi values, defined at i=n as the roots of the nth order Legendre polynomial Pn(x))
    static const CGFloat Tvalues[] = {
        -0.06405689286260562997910028570913709, 0.06405689286260562997910028570913709,
        -0.19111886747361631067043674647720763, 0.19111886747361631067043674647720763,
        -0.31504267969616339684080230654217302, 0.31504267969616339684080230654217302,
        -0.43379350762604512725673089335032273, 0.43379350762604512725673089335032273,
        -0.54542147138883956269950203932239674, 0.54542147138883956269950203932239674,
        -0.64809365193697554552443307329667732, 0.64809365193697554552443307329667732,
        -0.74012419157855435791759646235732361, 0.74012419157855435791759646235732361,
        -0.82000198597390294708020519465208053, 0.82000198597390294708020519465208053,
        -0.88641552700440107148693869021371938, 0.88641552700440107148693869021371938,
        -0.93827455200273279789513480864115990, 0.93827455200273279789513480864115990,
        -0.97472855597130947380435372906504198, 0.97472855597130947380435372906504198,
        -0.99518721999702131064680088456952944, 0.99518721999702131064680088456952944
    };
    // Legendre-Gauss weights (wi values, defined by a function linked to in the Bezier primer article)
    static const CGFloat Cvalues[] = {
        0.12793819534675215932040259758650790, 0.12793819534675215932040259758650790,
        0.12583745634682830250028473528800532, 0.12583745634682830250028473528800532,
        0.12167047292780339140527701147220795, 0.12167047292780339140527701147220795,
        0.11550566805372559919806718653489951, 0.11550566805372559919806718653489951,
        0.10744427011596563437123563744535204, 0.10744427011596563437123563744535204,
        0.09761865210411388438238589060347294, 0.09761865210411388438238589060347294,
        0.08619016153195327434310968328645685, 0.08619016153195327434310968328645685,
        0.07334648141108029983925575834291521, 0.07334648141108029983925575834291521,
        0.05929858491543678333801636881617014, 0.05929858491543678333801636881617014,
        0.04427743881741980774835454326421313, 0.04427743881741980774835454326421313,
        0.02853138862893366337059042336932179, 0.02853138862893366337059042336932179,
        0.01234122979998720018302016399047715, 0.01234122979998720018302016399047715
    };
    
    if (SABezierIsStraight(pts)) {
        return SAPointDistance(pts[0], pts[3]);
    }
    
    CGFloat z2 = 0.5f;
    CGFloat sum = 0.f;
    
    for (int i = 0; i < 24; i++) {
        CGFloat corrected_t = z2 * Tvalues[i] + z2;
        sum += Cvalues[i] * cubicF(corrected_t, pts);
    }
    
    return z2 * sum;
}

CGFloat SABeziersLength(const CGPoint* pts, int count) {
    CGFloat len = 0;
    for (int i = 0; i + 3 < count; i += 3) {
        len += SABezierLength(pts + i);
    }
    return len;
}

void SABezierFromQuad(CGPoint pts[4], CGPoint start, CGPoint cp, CGPoint end) {
    CGPoint cp1 = SAPointAdd(start, SAPointMultiply(SAPointSubtract(cp, start), 2.0 / 3.0));
    CGPoint cp2 = SAPointAdd(end, SAPointMultiply(SAPointSubtract(cp, end), 2.0 / 3.0));
    pts[0] = start;
    pts[1] = cp1;
    pts[2] = cp2;
    pts[3] = end;
}

static void getPathLengthFunction(void *info, const CGPathElement *element) {
    CGPoint *data = (CGPoint *)info;
    CGFloat *len  = &data[0].x;
    CGPoint *lastpt = &data[1];
    CGPoint *start  = &data[2];
    
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            *lastpt = element->points[0];
            *start  = *lastpt;
            break;
        case kCGPathElementAddLineToPoint:
            *len += SAPointDistance(*lastpt, element->points[0]);
            *lastpt = element->points[0];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            SABezierFromQuad(data + 3, *lastpt, element->points[0], element->points[1]);
            *len += SABezierLength(data + 3);
            *lastpt = element->points[1];
            break;
        case kCGPathElementAddCurveToPoint:
            data[3] = *lastpt;
            for (int i = 0; i < 3; i++) {
                data[4 + i] = element->points[i];
            }
            *len += SABezierLength(data + 3);
            *lastpt = element->points[2];
            break;
        case kCGPathElementCloseSubpath:
            *len += SAPointDistance(*start, element->points[0]);
            break;
        default:
            break;
    }
}

CGFloat SAPathLength(CGPathRef path) {
    CGPoint data[7] = { CGPointZero, CGPointZero };
    CGPathApply(path, &data, getPathLengthFunction);
    return data[0].x;
}

void SABeziersFromEllipse90(CGPoint frompt, CGPoint topt, CGPoint *ctrpt1, CGPoint *ctrpt2)
{
    CGFloat rx = frompt.x - topt.x;
    CGFloat ry = topt.y - frompt.y;
    CGPoint center = CGPointMake(topt.x, frompt.y);
    
    const CGFloat M = 0.5522847498307933984022516; // 4(sqrt(2)-1)/3
    CGFloat dx = rx * M;
    CGFloat dy = ry * M;
    
    ctrpt1->x = center.x + rx;
    ctrpt1->y = center.y + dy;
    ctrpt2->x = center.x + dx;
    ctrpt2->y = center.y + ry;
}

void SABeziersFromEllipse(CGPoint pts[13], CGPoint center, CGFloat rx, CGFloat ry) {
    const CGFloat M = 0.5522847498307933984022516; // 4(sqrt(2)-1)/3
    CGFloat dx = rx * M;
    CGFloat dy = ry * M;
    
    pts[ 0].x = center.x + rx;  //   .   .   .   .   .
    pts[ 0].y = center.y;       //       4   3   2
    pts[ 1].x = center.x + rx;  //
    pts[ 1].y = center.y + dy;  //   5               1
    pts[ 2].x = center.x + dx;  //
    pts[ 2].y = center.y + ry;  //   6              0,12
    pts[ 3].x = center.x;       //
    pts[ 3].y = center.y + ry;  //   7               11
    
    pts[ 4].x = center.x - dx;  //       8   9   10
    pts[ 4].y = center.y + ry;
    pts[ 5].x = center.x - rx;
    pts[ 5].y = center.y + dy;
    pts[ 6].x = center.x - rx;
    pts[ 6].y = center.y;
    
    pts[ 7].x = center.x - rx;
    pts[ 7].y = center.y - dy;
    pts[ 8].x = center.x - dx;
    pts[ 8].y = center.y - ry;
    pts[ 9].x = center.x;
    pts[ 9].y = center.y - ry;
    
    pts[10].x = center.x + dx;
    pts[10].y = center.y - ry;
    pts[11].x = center.x + rx;
    pts[11].y = center.y - dy;
    pts[12].x = center.x + rx;
    pts[12].y = center.y;
}

CGPathRef SAPathCreateWithBeziers(const CGPoint* pts, int count, BOOL closed) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, pts[0].x, pts[0].y);
    for (int i = 1; i + 2 < count; i += 3) {
        CGPathAddCurveToPoint(path, nil, pts[i].x, pts[i].y, pts[i+1].x, pts[i+1].y, pts[i+2].x, pts[i+2].y);
    }
    if (closed) {
        CGPathCloseSubpath(path);
    }
    return path;
}

CGPathRef SAPathCreateWithLines(const CGPoint* pts, int count, BOOL closed) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, pts[0].x, pts[0].y);
    CGPathAddLines(path, nil, pts, count);
    if (closed) {
        CGPathCloseSubpath(path);
    }
    return path;
}

CGPathRef SAPathCreateWithRegularPolygon(int nside, CGPoint center, CGFloat radius, CGFloat startAngle) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat centralAngle = 2 * M_PI / (CGFloat)nside;
    
    for (int i = 0; i < nside; i++) {
        CGPoint pt = SAPointWithPolar(center, startAngle + centralAngle * (CGFloat)i, radius);
        if (i == 0)
            CGPathMoveToPoint(path, nil, pt.x, pt.y);
        else
            CGPathAddLineToPoint(path, nil, pt.x, pt.y);
    }
    CGPathCloseSubpath(path);
    return path;
}
