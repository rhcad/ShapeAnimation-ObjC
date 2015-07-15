//
//  SAShapeView+Image.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView+Image.h"
#import "SAPath.h"
#import "SAPoint.h"

@implementation SAShapeView (Image)

- (CAShapeLayer *)addRectangleLayer:(CGRect)frame {
    return [self addShapeLayer:[SAPath pathWithRect:frame].CGPath];
}

- (CAShapeLayer *)addEllipseLayer:(CGRect)frame {
    return [self addShapeLayer:[SAPath pathWithOvalInRect:frame].CGPath];
}

- (CAShapeLayer *)addCircleLayer:(CGPoint)center radius:(CGFloat)r {
    return [self addEllipseLayer:SARectWithCenter(center, 2 * r, 2 * r)];
}

- (CATextLayer *)addTextLayer:(NSString *)text frame:(CGRect)frame fontSize:(CGFloat)fontSize {
    if ([text length] < 1 || fontSize < 1) {
        return nil;
    }
    
    CATextLayer *layer = [CATextLayer layer];
    
    layer.string = text;
    layer.fontSize = fontSize;
    layer.foregroundColor = self.strokeColor.CGColor;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.wrapped = YES;
    [self addSublayer:layer frame:frame];
    
    return layer;
}

- (CATextLayer *)addTextLayer:(NSString *)text center:(CGPoint)pt fontSize:(CGFloat)fontSize {
    NSDictionary *attr = @{NSFontAttributeName: [SAFont systemFontOfSize:fontSize]};
    CGRect frame = SARectWithCenterSize(pt, [text sizeWithAttributes:attr]);
    return [self addTextLayer:text frame:frame fontSize:fontSize];
}

- (CALayer *)addImageLayer:(SAImage *)image center:(CGPoint)pt {
    if (image.size.width < 1 || image.size.height < 1) {
        return nil;
    }
    
    CALayer *layer = [CALayer layer];
    CGRect frame = SARectWithCenterSize(pt, image.size);
    
#ifdef UIKIT_EXTERN
    layer.contents = (__bridge id)(image.CGImage);
#else
    NSGraphicsContext *context = [[NSGraphicsContext currentContext] graphicsPort];
    NSRect rect = SARectFromSize(image.size);
    layer.contents = (__bridge id)([image CGImageForProposedRect:&rect context:context hints:NULL]);
#endif
    [self addSublayer:layer frame:frame];
    return layer;
}

- (CALayer *)addImageLayer:(CGPoint)center named:(NSString *)name {
    return [self addImageLayer:[SAImage imageNamed:name] center:center];
}

- (CALayer *)addImageLayer:(CGPoint)center contentsOfFile:(NSString *)file {
    SAImage *image = [[SAImage alloc] initWithContentsOfFile:file];
    return [self addImageLayer:image center:center];
}

@end
