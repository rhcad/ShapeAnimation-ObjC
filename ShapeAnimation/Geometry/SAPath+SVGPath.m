//
//  SAPath+SVGPath.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/11/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAPath.h"
#include <math.h>
#include <string.h>
#include <stdlib.h>

static bool svg_isspace(char c) {
    return strchr(" \t\n\v\f\r", c) != 0;
}

static bool svg_isdigit(char c) {
    return strchr("0123456789", c) != 0;
}

static bool svg_isnum(char c) {
    return strchr("0123456789+-.eE", c) != 0;
}

static const char* svg_getNextPathItem(const char* s, char* it)
{
    int i = 0;
    it[0] = '\0';
    // Skip white spaces and commas
    while (*s && (svg_isspace(*s) || *s == ',')) s++;
    if (!*s) return s;
    if (*s == '-' || *s == '+' || svg_isdigit(*s)) {
        // sign
        if (*s == '-' || *s == '+') {
            if (i < 63) it[i++] = *s;
            s++;
        }
        // integer part
        while (*s && svg_isdigit(*s)) {
            if (i < 63) it[i++] = *s;
            s++;
        }
        if (*s == '.') {
            // decimal point
            if (i < 63) it[i++] = *s;
            s++;
            // fraction part
            while (*s && svg_isdigit(*s)) {
                if (i < 63) it[i++] = *s;
                s++;
            }
        }
        // exponent
        if (*s == 'e' || *s == 'E') {
            if (i < 63) it[i++] = *s;
            s++;
            if (*s == '-' || *s == '+') {
                if (i < 63) it[i++] = *s;
                s++;
            }
            while (*s && svg_isdigit(*s)) {
                if (i < 63) it[i++] = *s;
                s++;
            }
        }
        it[i] = '\0';
    } else {
        // Parse command
        it[0] = *s++;
        it[1] = '\0';
        return s;
    }
    
    return s;
}

static int svg_getArgsPerElement(char cmd)
{
    switch (cmd) {
        case 'v':
        case 'V':
        case 'h':
        case 'H':
            return 1;
        case 'm':
        case 'M':
        case 'l':
        case 'L':
        case 't':
        case 'T':
            return 2;
        case 'q':
        case 'Q':
        case 's':
        case 'S':
            return 4;
        case 'c':
        case 'C':
            return 6;
        case 'a':
        case 'A':
            return 7;
    }
    return 0;
}

static CGFloat svg_sqr(CGFloat x) { return x*x; }
static CGFloat svg_vmag(CGFloat x, CGFloat y) { return sqrt(x*x + y*y); }

static CGFloat svg_vecrat(CGFloat ux, CGFloat uy, CGFloat vx, CGFloat vy)
{
    return (ux*vx + uy*vy) / (svg_vmag(ux,uy) * svg_vmag(vx,vy));
}

static CGFloat svg_vecang(CGFloat ux, CGFloat uy, CGFloat vx, CGFloat vy)
{
    CGFloat r = svg_vecrat(ux,uy, vx,vy);
    if (r < -1.0f) r = -1.0f;
    if (r > 1.0f) r = 1.0f;
    return ((ux*vy < uy*vx) ? -1.0f : 1.0f) * acos(r);
}

static void svg_xformPoint(CGFloat* dx, CGFloat* dy, CGFloat x, CGFloat y, const CGFloat* t)
{
    *dx = x*t[0] + y*t[2] + t[4];
    *dy = x*t[1] + y*t[3] + t[5];
}

static void svg_xformVec(CGFloat* dx, CGFloat* dy, CGFloat x, CGFloat y, const CGFloat* t)
{
    *dx = x*t[0] + y*t[2];
    *dy = x*t[1] + y*t[3];
}

static void svg_pathArcTo(CGMutablePathRef path, const CGFloat* args, bool rel)
{
    // Ported from canvg (https://code.google.com/p/canvg/)
    CGFloat rx, ry, rotx;
    CGFloat x1, y1, x2, y2, cx, cy, dx, dy, d;
    CGFloat x1p, y1p, cxp, cyp, s, sa, sb;
    CGFloat ux, uy, vx, vy, a1, da;
    CGFloat x, y, tanx, tany, a, px=0, py=0, ptanx=0, ptany=0, t[6];
    CGFloat sinrx, cosrx;
    int fa, fs;
    int i, ndivs;
    CGFloat hda, kappa;
    CGPoint end = CGPathGetCurrentPoint(path);
    
    rx = fabs(args[0]);				// y radius
    ry = fabs(args[1]);				// x radius
    rotx = args[2] * M_PI / 180.f;      // x rotation engle
    fa = fabs(args[3]) > 1e-6 ? 1 : 0;	// Large arc
    fs = fabs(args[4]) > 1e-6 ? 1 : 0;	// Sweep direction
    x1 = end.x;                          // start point
    y1 = end.y;
    if (rel) {							// end point
        x2 = end.x + args[5];
        y2 = end.y + args[6];
    } else {
        x2 = args[5];
        y2 = args[6];
    }
    
    dx = x1 - x2;
    dy = y1 - y2;
    d = sqrt(dx*dx + dy*dy);
    if (d < 1e-6f || rx < 1e-6f || ry < 1e-6f) {
        // The arc degenerates to a line
        CGPathAddLineToPoint(path, nil, x2, y2);
        return;
    }
    
    sinrx = sin(rotx);
    cosrx = cos(rotx);
    
    // Convert to center point parameterization.
    // http://www.w3.org/TR/SVG11/implnote.html#ArcImplementationNotes
    // 1) Compute x1', y1'
    x1p = cosrx * dx / 2.0f + sinrx * dy / 2.0f;
    y1p = -sinrx * dx / 2.0f + cosrx * dy / 2.0f;
    d = svg_sqr(x1p)/svg_sqr(rx) + svg_sqr(y1p)/svg_sqr(ry);
    if (d > 1) {
        d = sqrt(d);
        rx *= d;
        ry *= d;
    }
    // 2) Compute cx', cy'
    s = 0.0f;
    sa = svg_sqr(rx)*svg_sqr(ry) - svg_sqr(rx)*svg_sqr(y1p) - svg_sqr(ry)*svg_sqr(x1p);
    sb = svg_sqr(rx)*svg_sqr(y1p) + svg_sqr(ry)*svg_sqr(x1p);
    if (sa < 0.0f) sa = 0.0f;
    if (sb > 0.0f)
        s = sqrt(sa / sb);
    if (fa == fs)
        s = -s;
    cxp = s * rx * y1p / ry;
    cyp = s * -ry * x1p / rx;
    
    // 3) Compute cx,cy from cx',cy'
    cx = (x1 + x2)/2.0f + cosrx*cxp - sinrx*cyp;
    cy = (y1 + y2)/2.0f + sinrx*cxp + cosrx*cyp;
    
    // 4) Calculate theta1, and delta theta.
    ux = (x1p - cxp) / rx;
    uy = (y1p - cyp) / ry;
    vx = (-x1p - cxp) / rx;
    vy = (-y1p - cyp) / ry;
    a1 = svg_vecang(1.0f,0.0f, ux,uy);	// Initial angle
    da = svg_vecang(ux,uy, vx,vy);		// Delta angle
    
    //if (vecrat(ux,uy,vx,vy) <= -1.0f) da = M_PI;
    //if (vecrat(ux,uy,vx,vy) >= 1.0f) da = 0;
    
    if (fa) {
        // Choose large arc
        if (da > 0.0f)
            da = da - M_PI * 2;
        else
            da = M_PI * 2 + da;
    }
    
    // Approximate the arc using cubic spline segments.
    t[0] = cosrx; t[1] = sinrx;
    t[2] = -sinrx; t[3] = cosrx;
    t[4] = cx; t[5] = cy;
    
    // Split arc into max 90 degree segments.
    ndivs = (int)(fabs(da) / M_PI_2 + 0.5f);
    hda = (da / (CGFloat)ndivs) / 2.0f;
    kappa = fabs(4.0f / 3.0f * (1.0f - cos(hda)) / sin(hda));
    if (da < 0.0f)
        kappa = -kappa;
    
    for (i = 0; i <= ndivs; i++) {
        a = a1 + da * (i/(CGFloat)ndivs);
        dx = cos(a);
        dy = sin(a);
        svg_xformPoint(&x, &y, dx*rx, dy*ry, t); // position
        svg_xformVec(&tanx, &tany, -dy*rx * kappa, dx*ry * kappa, t); // tangent
        if (i > 0) {
            if (rel) {
                CGPathAddCurveToPoint(path, nil, px+ptanx+end.x, py+ptany+end.y,
                                      x-tanx+end.x, y-tany+end.y, x+end.x, y+end.y);
            } else {
                CGPathAddCurveToPoint(path, nil, px+ptanx, py+ptany, x-tanx, y-tany, x, y);
            }
        }
        px = x;
        py = y;
        ptanx = tanx;
        ptany = tany;
    }
}

static void svg_pathApplier(void *info, const CGPathElement *element)
{
    CGPoint* pts = (CGPoint*)info;
    int n = 0;
    
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            pts[0] = element->points[0];
            pts[1] = pts[0];
            n = 1;
            break;
        case kCGPathElementAddLineToPoint:
            pts[1] = pts[0];                // last point
            pts[0] = element->points[0];
            n = 1;
            break;
        case kCGPathElementAddQuadCurveToPoint:
            n = 2;
            break;
        case kCGPathElementAddCurveToPoint:
            n = 3;
            break;
        default:
            break;
    }
    if (n > 1) {
        for (int i = 0; i < n; ++i) {       // pts[0]: end point
            pts[i] = element->points[n - i - 1];
        }
    }
}

static CGPoint svg_outControlPoint(CGMutablePathRef path)
{
    CGPoint pts[3] = { CGPointZero, CGPointZero, CGPointZero };
    CGPathApply(path, pts, svg_pathApplier);
    return CGPointMake(2 * pts[0].x - pts[1].x, 2 * pts[0].y - pts[1].y);
}

@implementation SAPath (SVGPath)

// Convert path string as the ‘d’ attribute of SVG path to CGPath.
// The path string, as the ‘d’ attribute of SVG path, begins with a ‘M’ character and can contain
// instructions as described in http://www.w3.org/TR/SVGTiny12/paths.html

+ (SAPath *)pathWithSVGPath:(NSString *)d
{
    char item[64];
    char cmd = 0;
    CGFloat args[10] = { 0, 0, 0, 0, 0, 0 };
    int nargs = 0;
    int rargs = 0;
    CGPoint end;
    CGMutablePathRef path = CGPathCreateMutable();
    const char* s = d.UTF8String;
    
    while (*s) {
        s = svg_getNextPathItem(s, item);
        if (!*item) break;
        if (!svg_isnum(item[0])) {
            cmd = item[0];
            rargs = svg_getArgsPerElement(cmd);
            nargs = 0;
            if (cmd == 'Z' || cmd == 'z') {
                CGPathCloseSubpath(path);
            }
        } else {
            if (nargs < 10)
                args[nargs++] = atof(item);
            if (nargs >= rargs) {
                switch (cmd) {
                    case 'm':
                    case 'M':
                        if (cmd == 'm') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathMoveToPoint(path, nil, args[0]+end.x, args[1]+end.y);
                        } else {
                            CGPathMoveToPoint(path, nil, args[0], args[1]);
                        }
                        // Moveto can be followed by multiple coordinate pairs,
                        // which should be treated as linetos.
                        cmd = (cmd == 'm') ? 'l' : 'L';
                        rargs = svg_getArgsPerElement(cmd);
                        break;
                    case 'l':
                    case 'L':
                        if (cmd == 'l') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathAddLineToPoint(path, nil, args[0]+end.x, args[1]+end.y);
                        } else {
                            CGPathAddLineToPoint(path, nil, args[0], args[1]);
                        }
                        break;
                    case 'H':
                    case 'h':
                        end = CGPathGetCurrentPoint(path);
                        CGPathAddLineToPoint(path, nil, cmd == 'h' ? args[0] + end.x : args[0], end.y);
                        break;
                    case 'V':
                    case 'v':
                        end = CGPathGetCurrentPoint(path);
                        CGPathAddLineToPoint(path, nil, end.x, cmd == 'v' ? args[0] + end.y : args[0]);
                        break;
                    case 'C':
                    case 'c':
                        if (cmd == 'c') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathAddCurveToPoint(path, nil, args[0]+end.x, args[1]+end.y,
                                                  args[2]+end.x, args[3]+end.y, args[4]+end.x, args[5]+end.y);
                        } else {
                            CGPathAddCurveToPoint(path, nil, args[0], args[1], args[2], args[3], args[4], args[5]);
                        }
                        break;
                    case 'S':
                    case 's': {
                        CGPoint cp1 = svg_outControlPoint(path);
                        if (cmd == 's') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathAddCurveToPoint(path, nil, cp1.x, cp1.y, args[0]+end.x, args[1]+end.y,
                                                  args[2]+end.x, args[3]+end.y);
                        } else {
                            CGPathAddCurveToPoint(path, nil, cp1.x, cp1.y, args[0], args[1], args[2], args[3]);
                        }
                        break;
                    }
                    case 'Q':
                    case 'q':
                        if (cmd == 'q') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathAddQuadCurveToPoint(path, nil, args[0]+end.x, args[1]+end.y,
                                                      args[2]+end.x, args[3]+end.y);
                        } else {
                            CGPathAddQuadCurveToPoint(path, nil, args[0], args[1], args[2], args[3]);
                        }
                        break;
                    case 'T':
                    case 't': {
                        CGPoint cp1 = svg_outControlPoint(path);
                        if (cmd == 't') {
                            end = CGPathGetCurrentPoint(path);
                            CGPathAddQuadCurveToPoint(path, nil, cp1.x, cp1.y, args[0]+end.x, args[1]+end.y);
                        } else {
                            CGPathAddQuadCurveToPoint(path, nil, cp1.x, cp1.y, args[0], args[1]);
                        }
                        break;
                    }
                    case 'A':
                    case 'a':
                        svg_pathArcTo(path, args, cmd == 'a' ? 1 : 0);
                        break;
                    default:
                        break;
                }
                nargs = 0;
            }
        }
    }
    
    return [SAPath pathWithCGPath:path];
}

@end
