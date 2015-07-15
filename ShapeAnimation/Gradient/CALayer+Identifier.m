//
//  CALayer+Identifier.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "CALayer+Identifier.h"
#import <objc/runtime.h>

@implementation CALayer (Identifier)

- (NSString *)identifier {
    id obj = objc_getAssociatedObject(self, @"identifier");
    return [obj isKindOfClass:NSString.class] ? obj : nil;
}

- (void)setIdentifier:(NSString *)newValue {
    objc_setAssociatedObject(self, @"identifier", newValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)enumerateLayers:(void (^)(CALayer *))block {
    NSArray *sublayers = self.sublayers.copy;
    for (CALayer *layer in sublayers) {
        block(layer);
    }
}

@end

@implementation CALayer (Tap)

- (SALayerTap)didTap {
    return (SALayerTap)objc_getAssociatedObject(self, @"didTap");
}

- (void)setDidTap:(SALayerTap)newValue {
    objc_setAssociatedObject(self, @"didTap", newValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
