//
//  ViewController.m
//  ShapeAnimation_OSXDemo
//
//  Created by Zhang Yungui on 15/3/9.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "ViewController.h"
#import "ShapeAnimation.h"

@implementation ViewController

- (void)loadView {
    [super loadView];
    [self testMoveLines:self.shapeView];
}

- (void)testMoveLines:(SAShapeView *)view {
    CGPathRef path = CGPathFromSVGPath(@"M120,70 C0,200 150,375 250,220 T500,220");
    
    // Add a triangle with gradient fill
    CAShapeLayer *la1 = [view addShapeLayer:CGPathFromSVGPath(@"M10,20L80,40 20,100Z")];
    la1.gradient = [SAGradient gradient:@[(id)CGColorFromRGBA(0.5, 0.5, 0.9, 1.0),
                                          (id)CGColorFromRGBA(0.9, 0.9, 0.3, 1.0)]];
    
    // Move and rotate the triangle along the path
    SAAnimationPair *a1 = [[la1 moveOnPathAnimation:path] setDuration:1.6];
    SAAnimationPair *a2 = [la1.rotate360Degrees forever];
    [[CAAnimationGroup group:@[a1, a2]].autoreverses.forever apply];
    
    // Show the path with animated color
    CAShapeLayer *guild = [view addShapeLayer:path];
    [[guild strokeColorAnimation:SAColor.redColor.CGColor
                              to:SAColor.yellowColor.CGColor].autoreverses.forever apply];
    
    // Rotate and move a picture along the path
    CALayer *imageLayer = [view addImageLayer:CGPointMake(200, 200) named:@"airship.png"];
    imageLayer.opacity = 0.7f;
    [[[imageLayer moveOnPathAnimation:path autoRotate:YES] setBeginTime:1.0] applyWithDuration:4];
    
    // Test hit-testing and dragging
    view.didTap = ^(SAShapeView *view, CGPoint point) {
        [view removeSelectionBorders];
        CALayer *layer = [view hitTestLayer:point];
        if (layer) {
            [layer.tapAnimation apply:^{
                [view addSelectionBorder:layer];
            }];
        }
    };
    __block NSArray *selectedLayers = nil;
    view.didPan = ^(SAShapeView *view, SAPanRecognizer *sender) {
        if (sender.state == SAGestureBegan) {
            selectedLayers = view.selectedLayers;
            [view removeSelectionBorders];
        }
        else if (sender.state == SAGestureChanged) {
            CGPoint translation = [sender translationInView:view];
            [sender setTranslation:CGPointZero inView:view];
            for (CALayer *layer in selectedLayers) {
                [CAAnimation suppressAnimation:^{
                    layer.position = SAPointAdd(layer.position, translation);
                }];
            }
        }
        else if (sender.state == SAGestureEnded) {
            if ([selectedLayers containsObject:guild]) {
                [[la1 moveOnPathAnimation:guild.pathToSuperlayer.CGPath]
                 .autoreverses.forever applyWithDuration:2];
            }
            [view addSelectionBorders:selectedLayers];
            selectedLayers = nil;
        }
    };
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
