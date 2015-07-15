//
//  HamburgerButton.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/3/12.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "HamburgerButton.h"

// Modified from https://github.com/robb/hamburger-button
@interface HamburgerButton() {
    CAShapeLayer    *top;
    CAShapeLayer    *bottom;
    CAShapeLayer    *middle;
    BOOL            showsMenu;
    CGFloat         menuStart;
    CGFloat         menuEnd;
    CGFloat         hamburgerStart;
    CGFloat         hamburgerEnd;
}
@end

@implementation HamburgerButton

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
    self.frame = SARectWithCenter(SARectCenter(self.frame), 40, 40);
    SASetButtonAction(self, self, @selector(toggle:));
    
    CGPathRef shortStroke = CGPathFromSVGPath(@"M1,1 h20");
    CGPathRef outline = CGPathFromSVGPath(@"M6,20 H30C41,20 36,1 20,1 9.5,1 1,9.5 1,20 1,30.5 9.5,39 20,39 "
                                          "30.5,39 39,30.5 39,20 39,9.5 30.5,1 20,1");
    CGPathRef startpath = CGPathFromSVGPath(@"M10,20 H30C41,20 36,1 20,1");
    
    top    = [SAShapeView addShapeLayer:shortStroke origin:CGPointMake(10, 20-6) superlayer:self.layer];
    bottom = [SAShapeView addShapeLayer:shortStroke origin:CGPointMake(10, 20+6) superlayer:self.layer];
    middle = [SAShapeView addShapeLayer:outline center:CGPointMake(20, 20) superlayer:self.layer];
    
    for (CAShapeLayer *layer in @[top, middle, bottom]) {
        layer.strokeColor = SAColor.blackColor.CGColor;
        layer.lineWidth = 2;
        layer.lineCap = kCALineCapButt;
        layer.bounds = layer.strokingBounds;
    }
    
    CGFloat length  = SAPathLength(outline);
    menuStart       = SAPathLength(startpath) / length;
    menuEnd         = 1;
    hamburgerStart  = 4 / length;
    hamburgerEnd    = 24 / length;
    
    middle.strokeStart = hamburgerStart;
    middle.strokeEnd = hamburgerEnd;
    [top setAnchorPointOnly:CGPointMake((10 + 7.5) / 20.0, 0.5)];
    [bottom setAnchorPointOnly:CGPointMake((10 + 7.5) / 20.0, 0.5)];
}

- (IBAction)toggle:(id)sender {
    showsMenu = !showsMenu;
    if (showsMenu) {
        [[[middle strokeStartAnimation:menuStart] setTimingFunction:0.25 :-0.4 :0.5 :1] applyWithDuration:0.5];
        [[[middle strokeEndAnimation:menuEnd] setTimingFunction:0.25 :-0.4 :0.5 :1] applyWithDuration:0.6];
    } else {
        [[[[middle strokeStartAnimation:hamburgerStart] setTimingFunction:0.25 :0 :0.5 :1.2]
          setBeginTime:0.1] applyWithDuration:0.5];
        [[[middle strokeEndAnimation:hamburgerEnd] setTimingFunction:0.25 :0.3 :0.5 :0.9] applyWithDuration:0.6];
    }
    
    CATransform3D translation = CATransform3DMakeTranslation(-3, 0, 0);
    CATransform3D xftop = CATransform3DRotate(translation, -M_PI_4, 0, 0, 1);
    CATransform3D xfbot = CATransform3DRotate(translation,  M_PI_4, 0, 0, 1);
    
    [[[top transformAnimation:showsMenu ? xftop : CATransform3DIdentity]
      setTimingFunction:0.5 :-0.8 :0.5 :1.85]
     applyWithDuration:0.4];
    
    [[[[bottom transformAnimation:showsMenu ? xfbot : CATransform3DIdentity]
       setTimingFunction:0.5 :-0.8 :0.5 :1.85]
      setBeginTime:showsMenu ? 0.2 : 0.05] applyWithDuration:0.4];
}

@end
