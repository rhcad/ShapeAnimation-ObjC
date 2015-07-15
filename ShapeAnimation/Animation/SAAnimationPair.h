//
//  SAAnimationPair.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SAAnimationPair : NSObject

@property (weak,   nonatomic)   CALayer     *layer;
@property (strong, nonatomic)   CAAnimation *animation;
@property (copy,   nonatomic)   NSString    *key;

+ (SAAnimationPair *)pair:(CALayer *)layer :(CAPropertyAnimation *)animation;
+ (SAAnimationPair *)pair:(CALayer *)layer :(CAAnimation *)animation key:(NSString *)key;
- (SAAnimationPair *)setWillStop:(void (^)(CALayer *))block;

- (void)apply;
- (void)apply:(dispatch_block_t)didStop;
- (void)applyWithDuration:(CFTimeInterval)duration;
- (void)applyWithDuration:(CFTimeInterval)duration didStop:(dispatch_block_t)didStop;

- (SAAnimationPair *)set:(void (^)(CAAnimation *))block;
- (SAAnimationPair *)setStop:(dispatch_block_t)didStop;
- (SAAnimationPair *)setTimingFunction:(CAMediaTimingFunction *)function;
- (SAAnimationPair *)setTimingFunction:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
- (SAAnimationPair *)setFillMode:(NSString *)fillMode;
- (SAAnimationPair *)setDuration:(CFTimeInterval)duration;

- (SAAnimationPair *)setBeginTime:(CFTimeInterval)time;
- (SAAnimationPair *)setBeginTime:(int)index gap:(CFTimeInterval)gap;
- (SAAnimationPair *)setBeginTime:(int)index gap:(CFTimeInterval)gap duration:(CFTimeInterval)d;

- (SAAnimationPair *)setRepeatCount:(float)count;
- (SAAnimationPair *)forever;
- (SAAnimationPair *)autoreverses;

@end

@interface CAAnimationGroup (Pair)
+ (SAAnimationPair *)group:(NSArray *)animations;
@end

@interface CATransaction (Group)
+ (void)apply:(NSArray *)animations completion:(dispatch_block_t)completion;
+ (void)apply:(NSArray *)animations completion:(dispatch_block_t)c timingFunction:(CAMediaTimingFunction *)f;
@end

@interface CAAnimation (Suppress)

+ (void)suppressAnimation:(dispatch_block_t)block;

@end
