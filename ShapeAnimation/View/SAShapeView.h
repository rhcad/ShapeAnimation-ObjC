//
//  SAShapeView.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SAPortability.h"


@interface SAShapeView : SAView

#pragma mark - Properties for new CAShapeLayer objects

@property(copy, nonatomic)  SAColor    *fillColor;          // Defaults to nil
@property(copy, nonatomic)  SAColor    *strokeColor;        // Defaults to opaque black
@property(nonatomic)        CGFloat     lineWidth;          // Defaults to one
@property(copy, nonatomic)  NSString    *lineCap;           // Defaults to kCALineCapButt
@property(copy, nonatomic)  NSString    *lineJoin;          // Defaults to kCALineJoinRound
@property(nonatomic)        CGFloat     dashPhase;          // Defaults to zero
@property(copy, nonatomic)  NSArray     *dashPattern;       // Defaults to nil

#pragma mark - Add layers

- (void)addSublayer:(CALayer *)layer frame:(CGRect)frame;
+ (void)addSublayer:(CALayer *)layer frame:(CGRect)frame superlayer:(CALayer *)sl;

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path;
- (CAShapeLayer *)addShapeLayer:(CGPathRef)path frame:(CGRect)frame;
- (CAShapeLayer *)addShapeLayer:(CGPathRef)path center:(CGPoint)pt;
- (CAShapeLayer *)addShapeLayer:(CGPathRef)path origin:(CGPoint)pt;
- (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect center:(CGPoint)pt;
- (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect origin:(CGPoint)pt;

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path superlayer:(CALayer *)sl;
+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path frame:(CGRect)frame superlayer:(CALayer *)sl;
+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path center:(CGPoint)pt superlayer:(CALayer *)sl;
+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path origin:(CGPoint)pt superlayer:(CALayer *)sl;
+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect center:(CGPoint)pt superlayer:(CALayer *)sl;
+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect origin:(CGPoint)pt superlayer:(CALayer *)sl;

- (void)enumerateLayers:(void (^)(CALayer *))block;
- (void)removeLayers;

@end


@interface CALayer (Remove)

- (void)removeLayer;

@end
