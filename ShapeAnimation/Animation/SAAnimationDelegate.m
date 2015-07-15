//
//  SAAnimationDelegate.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationDelegate.h"

static int stopping = 0;

@implementation SAAnimationDelegate

- (instancetype)init {
    if (self = [super init]) {
        self.finished = YES;
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.finished = flag;
    if (flag) {
        if (self.willStop) {
            self.willStop(anim);
        }
        if (self.didStop) {
            self.didStop();
            self.didStop = nil;
        }
    } else {
        stopping++;
        if (self.willStop) {
        }
        if (self.didStop) {
            self.didStop();
        }
        stopping--;
    }
}

+ (void)groupDidStop:(dispatch_block_t)completion finished:(BOOL)flag {
    if (flag) {
        completion();
    } else {
        stopping++;
        completion();
        stopping--;
    }
}

@end

@implementation CAAnimation (SADelegate)

- (dispatch_block_t)didStop {
    SAAnimationDelegate *delegate = self.delegate;
    return [delegate isKindOfClass:SAAnimationDelegate.class] ? delegate.didStop : nil;
}

- (void)setDidStop:(dispatch_block_t)newValue {
    SAAnimationDelegate *delegate = self.delegate;
    if ([delegate isKindOfClass:SAAnimationDelegate.class]) {
        delegate.didStop = newValue;
    } else if (newValue) {
        delegate = [[SAAnimationDelegate alloc]init];
        delegate.didStop = newValue;
        self.delegate = delegate;
    }
}

- (SAWillStopBlock)willStop {
    SAAnimationDelegate *delegate = self.delegate;
    return [delegate isKindOfClass:SAAnimationDelegate.class] ? delegate.willStop : nil;
}

- (void)setWillStop:(SAWillStopBlock)newValue {
    SAAnimationDelegate *delegate = self.delegate;
    if ([delegate isKindOfClass:SAAnimationDelegate.class]) {
        delegate.willStop = newValue;
    } else if (newValue) {
        delegate = [[SAAnimationDelegate alloc]init];
        delegate.willStop = newValue;
        self.delegate = delegate;
    }
}

- (BOOL)finished {
    SAAnimationDelegate *delegate = self.delegate;
    return [delegate isKindOfClass:SAAnimationDelegate.class] ? delegate.finished : true;
}

- (void)setFinished:(BOOL)newValue {
    SAAnimationDelegate *delegate = self.delegate;
    if ([delegate isKindOfClass:SAAnimationDelegate.class]) {
        delegate.finished = newValue;
    } else if (newValue) {
        delegate = [[SAAnimationDelegate alloc]init];
        delegate.finished = newValue;
        self.delegate = delegate;
    }
}

+ (BOOL)isStopping {
    return stopping > 0;
}

@end
