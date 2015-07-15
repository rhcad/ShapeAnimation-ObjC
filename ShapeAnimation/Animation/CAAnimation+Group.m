//
//  CAAnimation+Group.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"
#import "SAAnimationDelegate.h"

@implementation CAAnimationGroup (Pair)

+ (SAAnimationPair *)group:(NSArray *)animations {
    CAAnimationGroup *grpup = CAAnimationGroup.animation;
    CALayer *layer = nil;
    NSMutableArray *arr = NSMutableArray.array;
    
    for (SAAnimationPair *item in animations) {
        NSParameterAssert([item isKindOfClass:SAAnimationPair.class]);
        NSParameterAssert(!layer || layer == item.layer);
        layer = item.layer;
        [arr addObject:item.animation];
        grpup.duration = MAX(item.animation.duration, grpup.duration);
    }
    grpup.animations = arr;
    return [SAAnimationPair pair:layer :grpup key:@"group"];
}

@end

@implementation CATransaction (Group)

+ (void)apply:(NSArray *)animations completion:(dispatch_block_t)completion {
    CAMediaTimingFunction *f = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [CATransaction apply:animations completion:completion timingFunction:f];
}

+ (void)apply:(NSArray *)animations completion:(dispatch_block_t)c timingFunction:(CAMediaTimingFunction *)f {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:f];
    
    CFTimeInterval duration = 0, start = CACurrentMediaTime();
    for (SAAnimationPair *item in animations) {
        NSParameterAssert([item isKindOfClass:SAAnimationPair.class]);
        CAAnimation *anim = item.animation;
        duration = MAX(anim.duration, MAX(anim.beginTime - start, 0) + duration);
        anim.finished = YES;  // create delegate
        [item apply];
    }
    [CATransaction setAnimationDuration:duration];
    
    if (c) {
        [CATransaction setCompletionBlock: ^{
            BOOL finished = YES;
            for (SAAnimationPair *item in animations) {
                finished = item.animation.finished && finished;
            }
            [SAAnimationDelegate groupDidStop:c finished:finished];
        }];
    }
    
    [CATransaction commit];
}

@end
