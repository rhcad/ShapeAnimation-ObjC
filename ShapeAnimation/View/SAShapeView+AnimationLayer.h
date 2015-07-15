//
//  SAShapeView+AnimationLayer.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/13.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"

@class SAAnimationLayer;

@interface SAShapeView (AnimationLayer)

- (SAAnimationLayer *)addAnimationLayer:(NSArray *)properties;

@end

@interface SAAnimationLayerView : SAShapeView

@property (readonly, nonatomic) SAAnimationLayer    *animationLayer;

@end
