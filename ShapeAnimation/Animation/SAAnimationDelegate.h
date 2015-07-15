//
//  SAAnimationDelegate.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^SAWillStopBlock)(CAAnimation *);

@interface SAAnimationDelegate : NSObject

@property (copy, nonatomic)     dispatch_block_t    didStop;
@property (copy, nonatomic)     SAWillStopBlock     willStop;
@property (nonatomic)           BOOL                finished;

+ (void)groupDidStop:(dispatch_block_t)completion finished:(BOOL)flag;

@end

@interface CAAnimation (SADelegate)

@property (copy, nonatomic)     dispatch_block_t    didStop;
@property (copy, nonatomic)     SAWillStopBlock     willStop;
@property (nonatomic)           BOOL                finished;

+ (BOOL)isStopping;

@end

@interface CAAnimation (SAInternal)

+ (void)suppressAnimation:(CALayer *)layer :(CAAnimation *)animation key:(NSString *)key :(void (^)(CALayer *))block;
+ (void)suppressAnimation:(CALayer *)layer :(CAPropertyAnimation *)animation :(void (^)(CALayer *))block;
- (void)setDefaultProperties:(CALayer *)layer defaultFromValue:(id)from;
- (void)setDefaultProperties:(CALayer *)layer defaultFromValue:(id)from timingFunction:(NSString *)name;

@end
