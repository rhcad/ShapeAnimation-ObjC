//
//  SAShapeView+AnimationLayer.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/13.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView+AnimationLayer.h"
#import "SAAnimationLayer.h"

@implementation SAShapeView (AnimationLayer)

- (SAAnimationLayer *)addAnimationLayer:(NSArray *)properties {
    SAAnimationLayer *layer = [SAAnimationLayer layer:properties];
    [self addSublayer:layer frame:self.bounds];
    return layer;
}

@end

@implementation SAAnimationLayerView

+ (Class)layerClass {
    return [SAAnimationLayer class];
}

- (SAAnimationLayer *)animationLayer {
    return (SAAnimationLayer *)self.layer;
}

@end
