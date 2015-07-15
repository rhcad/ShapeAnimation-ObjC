//
//  CGContext+Gradient.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/7.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CGContext+Gradient.h"

@implementation SAGradient

@synthesize colors = colors_;
@synthesize locations = locations_;
@synthesize gradient = gradient_;

- (void)dealloc {
    CGGradientRelease(gradient_);
    gradient_ = nil;
}

+ (SAGradient *)gradient:(NSArray *)colors {
    return [SAGradient gradient:colors locations:nil axial:NO];
}

+ (SAGradient *)gradient:(NSArray *)colors axial:(BOOL)axial {
    return [SAGradient gradient:colors locations:nil axial:axial];
}

+ (SAGradient *)gradient:(NSArray *)colors locations:(NSArray *)ls axial:(BOOL)axial {
    SAGradient *obj = [[SAGradient alloc] init];
    obj.colors = colors;
    obj.locations = ls;
    obj.startPoint = CGPointMake(0.5f, axial ? 0.5f : 0.f);
    obj.endPoint = CGPointMake(0.5, axial ? 0.5f : 1.f);
    obj.axial = axial;
    return obj;
}

- (void)setColors:(NSArray *)newValue {
    colors_ = newValue;
    CGGradientRelease(gradient_);
    gradient_ = nil;
}

- (void)setLocations:(NSArray *)newValue {
    locations_ = newValue;
    CGGradientRelease(gradient_);
    gradient_ = nil;
}

- (CGGradientRef)gradient {
    if (!gradient_) {
        CGFloat components[20], *pc = components;
        CGFloat positions[5], *pl = positions;
        bool valid = false;
        
        for (id c in colors_) {
            CGColorRef color = (__bridge CGColorRef)c;
            CGFloat alpha = CGColorGetAlpha(color);
            
            if (alpha < 0.01f) {
                for (int i = 0; i < 4; i++)
                    *pc++ = 0;
            } else {
                size_t n = CGColorGetNumberOfComponents(color);
                const CGFloat *arr = CGColorGetComponents(color);
                
                if (n == 2) {
                    for (int i = 0; i < 3; i++)
                        *pc++ = arr[0];
                    *pc++ = arr[1];
                }
                else if (n == 4) {
                    for (int i = 0; i < 4; i++)
                        *pc++ = arr[i];
                }
                valid = n == 2 || n == 4;
            }
        }
        
        if (valid) {
            if (locations_.count > 0) {
                for (NSNumber *num in locations_) {
                    *pl++ = [num floatValue];
                }
            }
            CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
            pl = locations_.count > 0 ? positions : nil;
            gradient_ = CGGradientCreateWithColorComponents(space, components, pl, colors_.count);
            CGColorSpaceRelease(space);
        }
    }
    
    return gradient_;
}

- (void)fillEllipseInContext:(CGContextRef)ctx rect:(CGRect)rect {
    [self fillEllipseInContext:ctx rect:rect transform:CGAffineTransformIdentity];
}

- (void)fillEllipseInContext:(CGContextRef)ctx rect:(CGRect)rect transform:(CGAffineTransform)xf {
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, xf);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self fillInContext:ctx rect:rect];
    CGContextRestoreGState(ctx);
}

- (void)fillPathInContext:(CGContextRef)ctx path:(CGPathRef)path {
    [self fillPathInContext:ctx path:path transform:CGAffineTransformIdentity];
}

- (void)fillPathInContext:(CGContextRef)ctx path:(CGPathRef)path transform:(CGAffineTransform)xf {
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, xf);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    [self fillInContext:ctx rect:CGPathGetPathBoundingBox(path)];
    CGContextRestoreGState(ctx);
}

- (void)fillInContext:(CGContextRef)ctx rect:(CGRect)rect {
    CGPoint p1 = CGPointMake(rect.origin.x + self.startPoint.x * rect.size.width,
                             rect.origin.y + self.startPoint.y * rect.size.height);
    CGPoint p2 = CGPointMake(rect.origin.x + self.endPoint.x * rect.size.width,
                             rect.origin.y + self.endPoint.y * rect.size.height);
    
    if (self.axial) {
        CGFloat rx = MAX(CGRectGetMaxX(rect) - p2.x, p2.x - CGRectGetMinX(rect));
        CGFloat ry = MAX(CGRectGetMaxY(rect) - p2.y, p2.y - CGRectGetMinY(rect));
        CGFloat len = (CGFloat) hypot(rect.size.width, rect.size.height);
        CGContextDrawRadialGradient(ctx, self.gradient, p1, 0, p2, MAX(MAX(rx, ry), len), 0);
    } else {
        CGContextDrawLinearGradient(ctx, self.gradient, p1, p2, 0);
    }
}

@end
