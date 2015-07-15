//
//  SAShapeView+Tap.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/11.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"

typedef void (^SAViewTap)(SAShapeView *view, CGPoint point);
typedef void (^SAViewPan)(SAShapeView *view, SAPanRecognizer *sender);

@interface SAShapeView (Tap)

@property (copy, nonatomic)     SAViewTap   didTap;
@property (copy, nonatomic)     SAViewPan   didPan;
@property (readonly, nonatomic) SATapRecognizer  *tapRecognizer;
@property (readonly, nonatomic) SAPanRecognizer  *panRecognizer;

@end
