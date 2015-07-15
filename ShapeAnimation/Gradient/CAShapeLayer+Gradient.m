//
//  CAShapeLayer+Gradient.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CAShapeLayer+Gradient.h"
#import "CGContext+Gradient.h"
#import <objc/runtime.h>

@implementation CALayer (GradientLayer)

- (CAGradientLayer *)gradientLayer {
    id obj = objc_getAssociatedObject(self, @"gradientLayer");
    return [obj isKindOfClass:CAGradientLayer.class] ? obj : nil;
}

- (void)setGradientLayer:(CAGradientLayer *)newValue {
    CAGradientLayer *oldlayer = [self gradientLayer];
    if (oldlayer) {
        [oldlayer removeAllAnimations];
        [oldlayer removeFromSuperlayer];
    } else if (!newValue) {
        return;
    }
    objc_setAssociatedObject(self, @"gradientLayer", newValue, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation CAShapeLayer (Gradient)

- (void)applyGradient:(void (^)(CAGradientLayer *))block {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CAShapeLayer *maskLayer = CAShapeLayer.layer;
    
    maskLayer.frame = self.bounds;
    maskLayer.path = self.path;
    maskLayer.strokeColor = nil;
    
    gradientLayer.frame = self.frame;
    gradientLayer.mask = maskLayer;
    gradientLayer.contentsScale = self.contentsScale;
    gradientLayer.affineTransform = self.affineTransform;
    block(gradientLayer);
    
    [self.superlayer addSublayer:gradientLayer];
    self.fillColor = nil;
    self.gradientLayer = gradientLayer;
}

- (SAGradient *)gradient {
    CAGradientLayer *layer = self.gradientLayer;
    if (!layer) {
        return nil;
    }
    
    SAGradient *gradient = [SAGradient gradient:layer.colors locations:layer.locations
                                          axial:[layer.type isEqualToString:kCAGradientLayerAxial]];
    gradient.startPoint = layer.startPoint;
    gradient.endPoint = layer.endPoint;
    return gradient;
}

- (void)setGradient:(SAGradient *)newValue {
    if (!newValue || newValue.colors.count == 0) {
        self.gradientLayer = nil;
    } else {
        [self applyGradient:^(CAGradientLayer *layer) {
            layer.colors = newValue.colors;
            layer.locations = newValue.locations;
            layer.startPoint = newValue.startPoint;
            layer.endPoint = newValue.endPoint;
            if (newValue.axial) {
                layer.type = kCAGradientLayerAxial;
            }
        }];
    }
}

- (BOOL)filled {
    return self.fillColor || self.gradientLayer;
}

@end
