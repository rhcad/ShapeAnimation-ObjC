//
//  SAShapeView+Select.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView+Select.h"
#import "CAShapeLayer+Path.h"
#import "CAShapeLayer+Animations.h"
#import "CAShapeLayer+Gradient.h"
#import <objc/runtime.h>

@implementation SAShapeView (Select)

- (CALayer *)hitTestLayer:(CGPoint)point {
    return [self hitTestLayer:point filter:nil];
}

- (CALayer *)hitTestLayer:(CGPoint)point filter:(int (^)(CALayer *))filter {
    const CGFloat HITGAP = 10;
    __block CALayer *ret = nil;
    
    [self enumerateLayers: ^(CALayer *layer) {
        CALayer *present = layer.presentationLayer ? layer.presentationLayer : layer;
        BOOL contains = YES;
        
        if ([layer isKindOfClass:CAGradientLayer.class]
            || layer.hidden
            || !CGRectContainsPoint(CGRectInset(present.frame, -HITGAP, -HITGAP), point)) {
            return;
        }
        
        CGAffineTransform xf = CGAffineTransformMakeTranslation(-present.frame.origin.x, -present.frame.origin.y);
        xf = CGAffineTransformConcat(xf, present.affineTransform);
        
        if ([present isKindOfClass:CAShapeLayer.class]) {
            CAShapeLayer *shape = (CAShapeLayer *)present;
            
            if (shape.isSelectionBorder) {
                contains = NO;
            } else if (shape.closed && shape.filled) {
                contains = CGPathContainsPoint(shape.path, &xf, point, NO);
            } else {
                SAPath *path = [shape strokingPath:HITGAP];
                contains = CGPathContainsPoint(path.CGPath, &xf, point, NO);
            }
        }
        if (contains && (!filter || filter(layer))) {
            ret = layer;
        }
    }];
    
    return ret;
}

- (CAShapeLayer *)addSelectionBorder:(CALayer *)selected {
    CAShapeLayer *layer = CAShapeLayer.layer;
    CALayer      *present = selected.presentationLayer ? selected.presentationLayer : selected;
    CAShapeLayer *shape = (CAShapeLayer *) present;
    
    if ([shape isKindOfClass:CAShapeLayer.class]) {
        layer.path = [shape strokingPath:2 onlyOutline:YES].CGPath;
    } else {
        CGPathRef p = CGPathCreateWithRect(CGRectInset(present.bounds, -2, -2), nil);
        layer.path = p;
        CGPathRelease(p);
    }
    
    layer.transform = present.transform;
    layer.position = present.position;
    layer.anchorPoint = present.anchorPoint;
    layer.bounds = present.bounds;
    layer.fillColor = nil;
    layer.strokeColor = SAColor.blueColor.CGColor;
    layer.lineWidth = 0.8f;
    objc_setAssociatedObject(layer, @"selectedTarget", selected, OBJC_ASSOCIATION_ASSIGN);

    [layer.dashPhaseAnimation apply];
    [self addSublayer:layer frame: present.frame];
    
    return layer;
}

- (NSArray *)addSelectionBorders:(NSArray *)selectedLayers {
    NSMutableArray *arr = NSMutableArray.array;
    for (CALayer *layer in selectedLayers) {
        [arr addObject:[self addSelectionBorder:layer]];
    }
    return arr;
}

- (void)removeSelectionBorders {
    [self enumerateLayers: ^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]
            && [(CAShapeLayer *)layer isSelectionBorder]) {
            [layer removeLayer];
        }
    }];
}

- (NSArray *)selectedLayers {
    NSMutableArray *layers = NSMutableArray.array;
    [self enumerateLayers: ^(CALayer *layer) {
        if ([layer isKindOfClass:CAShapeLayer.class]
            && [(CAShapeLayer *)layer isSelectionBorder]) {
            [layers addObject:[(CAShapeLayer *)layer selectedTarget]];
        }
    }];
    return layers;
}

@end

@implementation CAShapeLayer (Select)

- (CALayer *)selectedTarget {
    return (CALayer *)objc_getAssociatedObject(self, @"selectedTarget");
}

- (BOOL)isSelectionBorder {
    return self.selectedTarget != nil;
}

@end
