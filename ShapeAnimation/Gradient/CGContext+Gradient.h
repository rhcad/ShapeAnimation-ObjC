//
//  CGContext+Gradient.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/7.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>


@interface SAGradient : NSObject

//! The array of CGColorRef objects defining the color of each gradient stop. Defaults to nil.
@property (copy, nonatomic)     NSArray         *colors;

//! An optional array of NSNumber objects defining the location of each gradient stop as a value in the range [0,1].
//! The values must be monotonically increasing. A nil array is assumed to [0,1] range. Defaults to nil.
@property (copy, nonatomic)     NSArray         *locations;

//! The start and end points of the gradient in the range [0,0] to [1,1].
//! The start point corresponds to the first gradient stop, the end point to the last gradient stop.
//! The default values are [.5,0] and [.5,1] for linear gradient and [.5,.5] and [.5,.5] for radial gradient respectively.
@property (nonatomic)           CGPoint         startPoint, endPoint;

@property (nonatomic)           BOOL            axial;

@property (readonly, nonatomic) CGGradientRef   gradient;

+ (SAGradient *)gradient:(NSArray *)colors;
+ (SAGradient *)gradient:(NSArray *)colors axial:(BOOL)axial;
+ (SAGradient *)gradient:(NSArray *)colors locations:(NSArray *)ls axial:(BOOL)axial;

- (void)fillInContext:(CGContextRef)ctx rect:(CGRect)rect;
- (void)fillEllipseInContext:(CGContextRef)ctx rect:(CGRect)rect;
- (void)fillEllipseInContext:(CGContextRef)ctx rect:(CGRect)rect transform:(CGAffineTransform)xf;
- (void)fillPathInContext:(CGContextRef)ctx path:(CGPathRef)path;
- (void)fillPathInContext:(CGContextRef)ctx path:(CGPathRef)path transform:(CGAffineTransform)xf;

@end
