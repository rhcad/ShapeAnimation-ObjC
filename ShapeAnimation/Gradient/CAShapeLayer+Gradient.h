//
//  CAShapeLayer+Gradient.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class SAGradient;

@interface CALayer (GradientLayer)

@property (weak, nonatomic)     CAGradientLayer *gradientLayer;

@end


@interface CAShapeLayer (Gradient)

@property (weak, nonatomic)     SAGradient      *gradient;
@property (readonly, nonatomic) BOOL            filled;

@end
