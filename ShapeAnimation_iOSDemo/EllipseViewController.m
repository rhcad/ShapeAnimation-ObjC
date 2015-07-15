//
//  EllipseViewController.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "EllipseViewController.h"
#import "ShapeAnimation.h"

@interface EllipseViewController () {
    SAAnimationLayer        *animationLayer_;
}
@end

@implementation EllipseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SAGradient *gradient = [SAGradient gradient:@[(id)CGColorFromRGBA(1,0,0,1),
                                                  (id)CGColorFromRGBA(0.1,0,0,0.1)] axial:YES];
    gradient.startPoint = CGPointMake(0.3, 0.3);
    
    animationLayer_ = ((SAAnimationLayerView *)self.shapeView).animationLayer;
    NSParameterAssert([animationLayer_ isKindOfClass:[SAAnimationLayer class]]);
    
    animationLayer_.properties = @[@"rx", @20, @"ry", @20, @"angle", @0];
    animationLayer_.drawBlock = ^(SAAnimationLayer *layer, CGContextRef ctx) {
        CGFloat rx = [layer getProperty:@"rx"];
        CGFloat ry = [layer getProperty:@"ry"];
        CGFloat angle = [layer getProperty:@"angle"] * M_PI / 360;
        
        CGPoint cen = SARectCenter(layer.bounds);
        CGAffineTransform xf = CGAffineTransformRotate(CGAffineTransformMakeTranslation(cen.x, cen.y), angle);
        CGRect rect = CGRectMake(-rx, -ry, 2 * rx, 2 * ry);
        
        [gradient fillEllipseInContext:ctx rect:rect transform:xf];
    };
    
    [self radiusXChanged:self.rxSlider];
    [self radiusYChanged:self.rySlider];
    [self angleChanged:self.angleSlider];
}

- (IBAction)radiusXChanged:(UISlider *)sender {
    [animationLayer_ setProperty:sender.value key:@"rx"];
}

- (IBAction)radiusYChanged:(UISlider *)sender {
    [animationLayer_ setProperty:sender.value key:@"ry"];
}

- (IBAction)angleChanged:(UISlider *)sender {
    [animationLayer_ setProperty:sender.value key:@"angle"];
}

@end
