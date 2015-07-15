//
//  SAPath.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/6.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface SAPath : NSObject

+ (SAPath *)pathWithCGPath:(CGPathRef)path;
+ (SAPath *)pathWithRect:(CGRect)rect;
+ (SAPath *)pathWithOvalInRect:(CGRect)rect;
+ (SAPath *)pathWithCircle:(CGPoint)center radius:(CGFloat)r;
+ (SAPath *)pathWithRegularPolygon:(int)nside center:(CGPoint)pt radius:(CGFloat)r startAngle:(CGFloat)a;

- (instancetype)initWithCGPath:(CGPathRef)path autoRetain:(BOOL)retain;
- (CGPathRef)CGPath;

@end

@interface SAPath (SVGPath)

+ (SAPath *)pathWithSVGPath:(NSString *)d;

@end

#define CGPathFromSVGPath(d) [SAPath pathWithSVGPath:d].CGPath
