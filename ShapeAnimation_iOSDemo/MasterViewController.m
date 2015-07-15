//
//  MasterViewController.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ShapeAnimation.h"

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320, 600.0);
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"Add Lines"]) {
        controller.animationBlock = self.testAddLines;
    } else if ([segue.identifier isEqualToString:@"Move Lines"]) {
        controller.animationBlock = self.testMoveLines;
    } else if ([segue.identifier isEqualToString:@"Rotate Polygons"]) {
        controller.animationBlock = self.testRotatePolygons;
    } else if ([segue.identifier isEqualToString:@"Radar Circles"]) {
        controller.animationBlock = self.testRadarCircles;
    } else if ([segue.identifier isEqualToString:@"Jumping Ball"]) {
        controller.animationBlock = self.testJumpingBall;
    }
    controller.title = NSLocalizedString(segue.identifier, nil);
}

// Demo about strokeEndAnimation, lineWidthAnimation, tapAnimation, shakeAnimation and addSelectionBorders.
- (AnimationBlock)testAddLines {
    return ^(SAShapeView *view) {
        view.lineWidth = 7;
        
        CAShapeLayer *a = [view addShapeLayer:CGPathFromSVGPath(@"M10,20L150,30 120,200Z") origin:CGPointMake(10, 10)];
        CAShapeLayer *b = [view addShapeLayer:CGPathFromSVGPath(@"M10,20L150,30 120,200 ") origin:CGPointMake(80, 30)];
        CAShapeLayer *c = [view addShapeLayer:CGPathFromSVGPath(@"M120,200L150,30 10,20Z") origin:CGPointMake(150, 50)];
        
        [[CAAnimationGroup group:@[a.strokeEndAnimation, [a lineWidthAnimation:0 to:5]]] apply:^{
            [[a shakeAnimation] apply];
            [[c flashAnimation:2] apply];
        }];
        
        a.strokeColor = UIColor.redColor.CGColor;
        b.strokeColor = UIColor.purpleColor.CGColor;
        c.strokeColor = UIColor.greenColor.CGColor;
        
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
                [view addSelectionBorders:selectedLayers];
                selectedLayers = nil;
            }
        };
    };
}

// Demo about didTap, moveOnPathAnimation, moveAnimation, rotationAnimation, dashPhaseAnimation and animationGroup.
// Rotate and move a picture and polygon with gradient fill along the path.
- (AnimationBlock)testMoveLines {
    return ^(SAShapeView *view) {
        CGPathRef path = CGPathFromSVGPath(@"M30,20 C0,50 50,175 130,80 T250,100");
        
        // Add a triangle with gradient fill
        CAShapeLayer *la1 = [view addShapeLayer:CGPathFromSVGPath(@"M10,20L50,40 20,80Z")];
        la1.gradient = [SAGradient gradient:@[(id)CGColorFromRGBA(0.5, 0.5, 0.9, 1.0),
                                              (id)CGColorFromRGBA(0.9, 0.9, 0.3, 1.0)]];
        
        // Move and rotate the triangle along the path
        SAAnimationPair *a1 = [[la1 moveOnPathAnimation:path] setDuration:1.6];
        SAAnimationPair *a2 = [la1.rotate360Degrees forever];
        [[CAAnimationGroup group:@[a1, a2]].autoreverses.forever apply];
        
        // Show the path with animated color
        CAShapeLayer *guild = [view addShapeLayer:path];
        [[guild strokeColorAnimation:SAColor.blueColor.CGColor
                                  to:SAColor.yellowColor.CGColor].autoreverses.forever apply];
        
        // Rotate and move a picture along the path
        CALayer *imageLayer = [view addImageLayer:CGPointMake(200, 200) named:@"airship.png"];
        imageLayer.opacity = 0.7f;
        [[[imageLayer moveOnPathAnimation:path autoRotate:YES] setBeginTime:1.0] applyWithDuration:4];
        
        CALayer *borderLayer = [view addSelectionBorder:imageLayer];
        [[[borderLayer moveOnPathAnimation:path autoRotate:YES]
          setBeginTime:1.0] applyWithDuration:4 didStop:^{
            [borderLayer removeLayer];
            [[imageLayer scaleAnimation:0] apply:^{
                [imageLayer removeLayer];
            }];
        }];
        
        // Test tapping
        view.didTap = ^(SAShapeView *view, CGPoint point) {
            CALayer *layer = [view hitTestLayer:point];
            if (layer.didTap) {
                layer.didTap(layer);
            } else {
                layer.paused = !layer.paused;
            }
        };
        imageLayer.didTap = ^(CALayer *layer) { [layer.rotate360Degrees apply]; };
    };
}

// Demo about polygon with text and gradient fill moving and rotating one by one.
// Modified from http://zulko.github.io/blog/2014/09/20/vector-animations-with-python/
- (AnimationBlock)testRotatePolygons {
    return ^(SAShapeView *view) {
        CGPathRef path = [SAPath pathWithRegularPolygon:5 center:CGPointMake(25, 25) radius:25 startAngle:0].CGPath;
        CGRect bounds = CGRectMake(0, 0, 50, 50);
        NSMutableArray *animations = NSMutableArray.array;
        NSArray *chars = @[@"T", @"E", @"S", @"T"];
        
        SAGradient *gradient = [SAGradient gradient:@[(id)CGColorFromRGBA(0, 0.5, 1, 1),
                                                      (id)CGColorFromRGBA(0, 1, 1, 1)]];
        gradient.startPoint = CGPointZero;
        gradient.endPoint = CGPointMake(1, 1);
        
        for (int i = 0; i < chars.count; i++) {
            CGPoint pt = CGPointMake(50 + 60*i, 50);
            CAShapeLayer *edge = [view addShapeLayer:path bounds:bounds center:pt];
            
            edge.gradient = gradient;
            
            CALayer *text = [view addTextLayer:[chars objectAtIndex:i] center:pt fontSize:30];
            
            [animations addObject:[[edge rotationAnimation:(5-i)*M_PI_2] setBeginTime:i gap:0.3 duration:1.5]];
            [animations addObject:[[text rotationAnimation:(5-i)*M_PI_2] setBeginTime:i gap:0.3 duration:1.5]];
        }
        [CATransaction apply:animations completion:^{
            for (int i = 0; i < animations.count; i++) {
                SAAnimationPair *pair = [animations objectAtIndex:i];
                [[[pair.layer moveAnimation:CGPointZero to:CGPointMake(300, 0) relative:YES]
                  setBeginTime:5 - i/2 gap:0.3] apply];
            }
        }];
    };
}

// Demo about growing circles.
- (AnimationBlock)testRadarCircles {
    return ^(SAShapeView *view) {
        int count = 8;
        float duration = 2;
        
        for (int i = 0; i < count; i++) {
            CAShapeLayer *a = [view addCircleLayer:CGPointMake(100, 100) radius:15];
            SAAnimationPair *p = [CAAnimationGroup group:@[[a scaleAnimation:0 to:5], [a opacityAnimation:1 to:0]]];
            [p setBeginTime:i gap:(duration / count) duration:duration];
            [[p.forever setFillMode:kCAFillModeBackwards] apply];
        }
        for (int i = 0; i < count; i++) {
            CAShapeLayer *a = [view addCircleLayer:CGPointMake(200, 100) radius:0.1];
            CGPathRef path = [SAPath pathWithCircle:CGPointZero radius:75].CGPath;
            SAAnimationPair *p = [CAAnimationGroup group:@[[a switchPathAnimation:path], [a opacityAnimation:1 to:0]]];
            [p setBeginTime:i gap:(duration / count) duration:duration];
            [[p.forever setFillMode:kCAFillModeBackwards] apply];
        }
    };
}

// Demo about jumping ball with shadow.
// Modified from http://zulko.github.io/blog/2014/09/20/vector-animations-with-python/
- (AnimationBlock)testJumpingBall {
    return ^(SAShapeView *view) {
        SAGradient *gradient = [SAGradient gradient:@[(id)CGColorFromRGBA(1,0,0,1),
                                                      (id)CGColorFromRGBA(0.1,0,0,1)] axial:YES];
        gradient.startPoint = CGPointMake(0.3, 0.3);
        
        SAAnimationLayer *layer = [view addAnimationLayer:@[@"t", @0]];
        layer.drawBlock = ^(SAAnimationLayer *layer, CGContextRef ctx) {
            CGFloat t = [layer getProperty:@"t"];
            CGFloat w = layer.bounds.size.width, h = layer.bounds.size.height;
            CGFloat d = 3, r = 30;                  // radius of ball
            CGFloat dj = w / 6, hj = h / 2;         // distance and height of jumping
            CGFloat ground = 0.75f * h;
            
            CGFloat x = (-w / 3) + (5 * w / 3) * (t / d);
            CGFloat xdj = fmodf(x, dj);
            CGFloat y = ground - hj * 4 * xdj * (dj - xdj) / (dj * dj);
            CGFloat coef = (hj - y) / hj;
            CGFloat sr = (1 - coef / 4) * r;
            
            CGRect shadow = CGRectMake(x - sr, ground + r/2 - sr/2, sr*2, sr);
            SAGradient *sgradient = [SAGradient gradient:@[(id)[UIColor colorWithWhite:0 alpha:0.2-coef/5].CGColor,
                                                           (id)UIColor.clearColor.CGColor] axial:YES];
            [sgradient fillEllipseInContext:ctx rect:shadow];
            
            CGRect ball = CGRectMake(x - r, y - r, r*2, r*2);
            [gradient fillEllipseInContext:ctx rect:ball];
        };
        
        layer.animationCreated = ^(SAAnimationLayer *layer, CABasicAnimation *anim) {
            anim.repeatCount = HUGE; anim.duration = 10;
        };
        [layer setProperty:4 key:@"t"];
    };
}

@end
