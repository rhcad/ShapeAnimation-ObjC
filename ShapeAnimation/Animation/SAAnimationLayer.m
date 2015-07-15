//
//  SAAnimationLayer.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationLayer.h"

@interface SAAnimationLayer() {
    NSArray         *keys_;
    NSMutableArray  *animations_;
}
@end

#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#import "CALayer+Pause.h"

static CVReturn renderCallback(CVDisplayLinkRef displayLink,
                               const CVTimeStamp *inNow,
                               const CVTimeStamp *inOutputTime,
                               CVOptionFlags flagsIn,
                               CVOptionFlags *flagsOut,
                               void *displayLinkContext)
{
    SAAnimationLayer *layer = (__bridge SAAnimationLayer *)displayLinkContext;
    if (!layer.paused) {
        [layer setNeedsDisplay];
    }
    return kCVReturnSuccess;
}
#endif

@implementation SAAnimationLayer

@synthesize properties = properties_;
@synthesize timer = timer_;

+ (SAAnimationLayer *)layer:(NSArray *)properties {
    SAAnimationLayer *layer = [SAAnimationLayer layer];
    layer.properties = properties;
    return layer;
}

- (void)setProperties:(NSArray *)newValue {
    NSMutableArray *arr = NSMutableArray.array;
    for (NSUInteger i = 0; i + 1 < [newValue count]; i += 2) {
        NSString *key = [newValue objectAtIndex:i];
        NSNumber *value = [newValue objectAtIndex:i + 1];
        
        NSParameterAssert([key isKindOfClass:NSString.class] && [value isKindOfClass:NSNumber.class]);
        [arr addObject:key];
        [self setValue:value forKey:key];
    }
    keys_ = arr;
    properties_ = newValue;
}

- (CGFloat)getProperty:(NSString *)key {
    CALayer *layer = self.presentationLayer ? self.presentationLayer : self;
    NSNumber *value = [layer valueForKey:key];
    return [value isKindOfClass:NSNumber.class] ? value.floatValue : 0;
}

- (void)setProperty:(CGFloat)value key:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

// MARK: Implementation

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self && [layer isKindOfClass:[SAAnimationLayer class]]) {
        SAAnimationLayer *src = (SAAnimationLayer *)layer;
        self.properties = src.properties;
        self.animationCreated = src.animationCreated;
        self.drawBlock = src.drawBlock;
    }
    return self;
}

- (BOOL)isPropertyAnimation:(CAAnimation *)anim {
    CAPropertyAnimation *animation = (CAPropertyAnimation *)anim;
    return ([animation isKindOfClass:[CAPropertyAnimation class]]
            && [keys_ containsObject:animation.keyPath]);
}

- (void)animationDidStart:(CAAnimation *)anim {
    if ([self isPropertyAnimation:anim]) {
        if (!animations_) {
            animations_ = NSMutableArray.array;
        }
        [animations_ addObject:anim];
        if (timer_ == nil) {
            if (self.didStart) {
                self.didStart();
            }
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
            timer_ = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationLoop:)];
            [timer_ addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
#else
            CGDirectDisplayID displayID = CGMainDisplayID();
            CVDisplayLinkCreateWithCGDisplay(displayID, &timer_);
            CVDisplayLinkSetOutputCallback(timer_, renderCallback, (__bridge void *)self);
            CVDisplayLinkStart(timer_);
#endif
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self isPropertyAnimation:anim]) {
        [animations_ removeObject:anim];
        if (animations_.count == 0) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
            [timer_ invalidate];
#else
            CVDisplayLinkStop(timer_);
            CVDisplayLinkRelease(timer_);
#endif
            timer_ = nil;
            if (self.didStop) {
                self.didStop();
            }
        }
    }
}

// Called when layer's property changes.
- (id<CAAction>)actionForKey:(NSString *)event {
    if ([keys_ containsObject:event]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.fromValue = @([self getProperty:event]);
        animation.delegate = self;
        animation.duration = 0.5;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        if (self.animationCreated) {
            self.animationCreated(self, animation);
        }
        [self addAnimation:animation forKey:event];
        return animation;
    }
    return [super actionForKey:event];
}

// Timer Callback
- (void)animationLoop:(NSObject *)sender {
    [self setNeedsDisplay];
}

// Layer Drawing
- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    if (self.drawBlock) {
        CGContextSetAllowsAntialiasing(ctx, true);
        CGContextSetShouldAntialias(ctx, true);
        self.drawBlock(self, ctx);
    }
}

@end
