//
//  SAShapeView+Image.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"


@interface SAShapeView (Image)

- (CAShapeLayer *)addRectangleLayer:(CGRect)frame;
- (CAShapeLayer *)addEllipseLayer:(CGRect)frame;
- (CAShapeLayer *)addCircleLayer:(CGPoint)center radius:(CGFloat)r;

- (CATextLayer *)addTextLayer:(NSString *)text frame:(CGRect)frame fontSize:(CGFloat)fontSize;
- (CATextLayer *)addTextLayer:(NSString *)text center:(CGPoint)pt fontSize:(CGFloat)fontSize;

- (CALayer *)addImageLayer:(SAImage *)image center:(CGPoint)pt;
- (CALayer *)addImageLayer:(CGPoint)center named:(NSString *)name;
- (CALayer *)addImageLayer:(CGPoint)center contentsOfFile:(NSString *)file;

@end
