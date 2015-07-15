//
//  SAShapeView+Tap.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/3/11.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView+Tap.h"
#import <objc/runtime.h>

@implementation SAShapeView (Tap)

- (SAViewTap)didTap {
    return (SAViewTap)objc_getAssociatedObject(self, @"didTap");
}

- (void)setDidTap:(SAViewTap)newValue {
    objc_setAssociatedObject(self, @"didTap", newValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!newValue) {
        [self removeGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer = nil;
    } else if (!self.tapRecognizer) {
        SATapRecognizer *r = [[SATapRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        self.tapRecognizer = r;
        [self addGestureRecognizer:r];
    }
}

- (SAViewPan)didPan {
    return (SAViewPan)objc_getAssociatedObject(self, @"didPan");
}

- (void)setDidPan:(SAViewPan)newValue {
    objc_setAssociatedObject(self, @"didPan", newValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!newValue) {
        [self removeGestureRecognizer:self.panRecognizer];
        self.panRecognizer = nil;
    } else if (!self.panRecognizer) {
        SAPanRecognizer *r = [[SAPanRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        self.panRecognizer = r;
        [self addGestureRecognizer:r];
#ifdef UIKIT_EXTERN
        r.maximumNumberOfTouches = 1;
#endif
    }
}

- (SATapRecognizer *)tapRecognizer {
    return (SATapRecognizer *)objc_getAssociatedObject(self, @"tapRecognizer");
}

- (void)setTapRecognizer:(SATapRecognizer *)newValue {
    objc_setAssociatedObject(self, @"tapRecognizer", newValue, OBJC_ASSOCIATION_ASSIGN);
}

- (SAPanRecognizer *)panRecognizer {
    return (SAPanRecognizer *)objc_getAssociatedObject(self, @"panRecognizer");
}

- (void)setPanRecognizer:(SAPanRecognizer *)newValue {
    objc_setAssociatedObject(self, @"panRecognizer", newValue, OBJC_ASSOCIATION_ASSIGN);
}

- (void)handleTapGesture:(SATapRecognizer *)sender {
    if (sender.state == SAGestureEnded) {
        self.didTap(self, [sender locationInView:self]);
    }
}

- (void)handlePanGesture:(SAPanRecognizer *)sender {
    self.didPan(self, sender);
}

@end
