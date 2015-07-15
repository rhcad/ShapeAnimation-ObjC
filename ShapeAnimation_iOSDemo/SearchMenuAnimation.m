//
//  SearchMenuAnimation.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/3/12.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SearchMenuAnimation.h"

@interface SearchMenuTextField () {
    CAShapeLayer    *pathLayer;
    CGFloat         offsetDist;
    CGFloat         joinParam;
}
@end

@implementation SearchMenuTextField

@synthesize srearchButton = button_;

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (!button_) {
        UIButton *button = [[UIButton alloc] initWithFrame:SARectFromSize(CGSizeMake(22, 22))];
        button.center = self.center;
        button_ = button;
        SASetButtonAction(button, self, @selector(searchButtonTapped:));
        [self.superview addSubview:button];
        [self initLayers];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    button_.center = self.center;
}

- (void)initLayers {
    self.borderStyle = UITextBorderStyleNone;
    self.hidden = YES;
    self.delegate = self;
    
    NSString *path1 = @"M15.3,15.3 A8.95 8.95 0 0 1 2.6 2.6,8.95 8.95 0 0 1 15.3,15.3L21,21";
    NSString *path2 = [path1 stringByAppendingFormat:@"h%.0f", -self.bounds.size.width];
    
    pathLayer = [SAShapeView addShapeLayer:CGPathFromSVGPath(path2) frame:CGRectZero superlayer:button_.layer];
    offsetDist = (self.bounds.size.width - button_.frame.size.width) / 2;
    joinParam  = SAPathLength(CGPathFromSVGPath(path1)) / SAPathLength(pathLayer.path);
    
    pathLayer.lineWidth = 1.5;
    pathLayer.strokeColor = SAColor.blueColor.CGColor;
    pathLayer.strokeEnd = joinParam;
}

- (IBAction)searchButtonTapped:(id)sender {
    self.hidden = NO;
    button_.enabled = NO;
    [[[CAAnimationGroup group:@[[pathLayer strokeStartAnimation:0 to:joinParam],
                                [pathLayer strokeEndAnimation:joinParam to:1],
                                [pathLayer lineWidthAnimation:1.5 to:0.7],
                                [pathLayer moveAnimation:CGPointMake(offsetDist, 0)]]]
      setFillMode:kCAFillModeForwards]apply:^{
        [self becomeFirstResponder];
    }];
}

- (void)tapViewToHidden:(id)view {
    [view addGestureRecognizer:[[SATapRecognizer alloc]initWithTarget:self action:@selector(resignFirstResponder)]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.hidden = YES;
    button_.enabled = YES;
    [[CAAnimationGroup group:@[[pathLayer strokeStartAnimation:joinParam to:0],
                               [pathLayer moveAnimation:CGPointMake(offsetDist, 0) to:CGPointZero relative:YES],
                               [pathLayer lineWidthAnimation:0.7 to:1.5],
                               [pathLayer strokeEndAnimation:1 to:joinParam]]] apply];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    return YES;
}

@end
