//
//  SAShapeView.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"
#import "CALayer+Identifier.h"
#import "CAShapeLayer+Gradient.h"
#import "SAPoint.h"

@implementation SAShapeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.strokeColor = SAColor.blackColor;
    self.lineWidth = 1;
    self.lineCap = kCALineCapButt;
    self.lineJoin = kCALineJoinRound;
#ifdef APPKIT_EXTERN
    self.wantsLayer = YES;
    self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.layer.contentsScale = NSScreen.mainScreen.backingScaleFactor;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
#endif
}

#pragma mark - removeFromSuperview, didMoveToSuperview and layoutSubviews

- (void)removeFromSuperview {
    [self removeLayers];
    [super removeFromSuperview];
}

- (void)removeLayers {
    [self enumerateLayers: ^(CALayer *layer) {
        [layer removeLayer];
    }];
}

#pragma mark - addShapeLayer and addSublayer

- (void)addSublayer:(CALayer *)layer frame:(CGRect)frame {
    [SAShapeView addSublayer:layer frame:frame superlayer:self.layer];
}

+ (void)addSublayer:(CALayer *)layer frame:(CGRect)frame superlayer:(CALayer *)sl {
    if (frame.size.width > 0 || frame.size.height > 0)
        layer.frame = frame;
#ifdef UIKIT_EXTERN
    layer.contentsScale = UIScreen.mainScreen.scale;
    layer.allowsEdgeAntialiasing = YES;
#else
    layer.contentsScale = NSScreen.mainScreen.backingScaleFactor;
#endif
    [sl addSublayer:layer];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path {
    return [self apply:[SAShapeView addShapeLayer:path superlayer:self.layer]];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path frame:(CGRect)frame {
    return [self apply:[SAShapeView addShapeLayer:path frame:frame superlayer:self.layer]];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect center:(CGPoint)pt {
    return [self apply:[SAShapeView addShapeLayer:path bounds:rect center:pt superlayer:self.layer]];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect origin:(CGPoint)pt {
    return [self apply:[SAShapeView addShapeLayer:path bounds:rect origin:pt superlayer:self.layer]];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path center:(CGPoint)pt {
    return [self addShapeLayer:path bounds:CGPathGetPathBoundingBox(path) center:pt];
}

- (CAShapeLayer *)addShapeLayer:(CGPathRef)path origin:(CGPoint)pt {
    return [self addShapeLayer:path bounds:CGPathGetPathBoundingBox(path) origin:pt];
}

- (CAShapeLayer *)apply:(CAShapeLayer *)layer {
    layer.fillColor = self.fillColor.CGColor;
    layer.strokeColor = self.strokeColor.CGColor;
    layer.lineWidth = self.lineWidth;
    layer.lineCap = self.lineCap;
    layer.lineJoin = self.lineJoin;
    layer.lineDashPhase = self.dashPhase;
    layer.lineDashPattern = self.dashPattern;
    return layer;
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path superlayer:(CALayer *)sl {
    CGRect box = CGPathGetPathBoundingBox(path);
    CGSize size = CGSizeMake(MAX(box.size.width, 0.01f), MAX(box.size.height, 0.01f));
    CGRect frame = CGRectMake(box.origin.x, box.origin.y, size.width, size.height);
    
    CAShapeLayer *layer = CAShapeLayer.layer;
    CGAffineTransform xf = CGAffineTransformMakeTranslation(-box.origin.x, -box.origin.y);
    CGPathRef newpath = path ? CGPathCreateCopyByTransformingPath(path, &xf) : nil;
    
    layer.path = newpath ? newpath : path;
    layer.fillColor = nil;
    [SAShapeView addSublayer:layer frame:frame superlayer:sl];
    CGPathRelease(newpath);
    
    return layer;
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path frame:(CGRect)frame superlayer:(CALayer *)sl {
    CAShapeLayer *layer = CAShapeLayer.layer;
    layer.path = path;
    layer.fillColor = nil;
    [SAShapeView addSublayer:layer frame:frame superlayer:sl];
    return layer;
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect center:(CGPoint)pt superlayer:(CALayer *)sl {
    rect = SARectWithCenterSize(pt, rect.size);
    return [SAShapeView addShapeLayer:path frame:rect superlayer:sl];
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path bounds:(CGRect)rect origin:(CGPoint)pt superlayer:(CALayer *)sl {
    rect.origin = pt;
    return [SAShapeView addShapeLayer:path frame:rect superlayer:sl];
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path center:(CGPoint)pt superlayer:(CALayer *)sl {
    return [SAShapeView addShapeLayer:path bounds:CGPathGetPathBoundingBox(path) center:pt superlayer:sl];
}

+ (CAShapeLayer *)addShapeLayer:(CGPathRef)path origin:(CGPoint)pt superlayer:(CALayer *)sl {
    return [SAShapeView addShapeLayer:path bounds:CGPathGetPathBoundingBox(path) origin:pt superlayer:sl];
}

#pragma mark - enumerateLayers

- (void)enumerateLayers:(void (^)(CALayer *))block {
    [self.layer enumerateLayers:block];
}

@end

@implementation CALayer (Remove)

- (void)removeLayer {
    self.gradientLayer = nil;
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}

@end
