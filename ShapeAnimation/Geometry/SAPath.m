//
//  SAPath.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/11/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAPath.h"
#import "SABezier.h"

@interface SAPath () {
    CGPathRef path_;
}
@end

@implementation SAPath

- (void)dealloc {
    CGPathRelease(self.CGPath);
}

- (CGPathRef)CGPath {
    return path_;
}

+ (SAPath *)pathWithCGPath:(CGPathRef)path {
    return [[SAPath alloc] initWithCGPath:path autoRetain:NO];
}

+ (SAPath *)pathWithRect:(CGRect)rect {
    return [SAPath pathWithCGPath:CGPathCreateWithRect(rect, nil)];
}

+ (SAPath *)pathWithOvalInRect:(CGRect)rect {
    return [SAPath pathWithCGPath:CGPathCreateWithEllipseInRect(rect, nil)];
}

+ (SAPath *)pathWithCircle:(CGPoint)center radius:(CGFloat)r {
    return [SAPath pathWithOvalInRect:SARectWithCenter(center, 2 * r, 2 * r)];
}

+ (SAPath *)pathWithRegularPolygon:(int)nside center:(CGPoint)pt radius:(CGFloat)r startAngle:(CGFloat)a {
    return [SAPath pathWithCGPath:SAPathCreateWithRegularPolygon(nside, pt, r, a)];
}

- (instancetype)initWithCGPath:(CGPathRef)path autoRetain:(BOOL)retain {
    if (self = [super init]) {
        path_ = path;
        if (retain) {
            CGPathRetain(path);
        }
    }
    return self;
}

@end
