//
//  SAShapeView+Pause.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView+Pause.h"
#import "CALayer+Pause.h"

@implementation SAShapeView (Pause)

- (BOOL)paused {
    __block BOOL ret = NO;
    [self enumerateLayers: ^(CALayer *layer) {
        ret = ret || layer.paused;
    }];
    return ret;
}

- (void)setPaused:(BOOL)newValue {
    [self enumerateLayers: ^(CALayer *layer) {
        layer.paused = newValue;
    }];
}

- (void)stopAnimations {
    [self enumerateLayers: ^(CALayer *layer) {
        [layer removeAllAnimations];
    }];
}

@end
