//
//  SAShapeView+Select.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"


@interface SAShapeView (Select)

- (CALayer *)hitTestLayer:(CGPoint)point;
- (CALayer *)hitTestLayer:(CGPoint)point filter:(int (^)(CALayer *))filter;

- (CAShapeLayer *)addSelectionBorder:(CALayer *)selected;
- (NSArray *)addSelectionBorders:(NSArray *)selectedLayers;
- (void)removeSelectionBorders;

- (NSArray *)selectedLayers;

@end


@interface CAShapeLayer (Select)

@property (readonly)            CALayer     *selectedTarget;
@property (readonly)            BOOL        isSelectionBorder;

@end
