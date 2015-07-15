//
//  SAAnimationLayer.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#define SADisplayLinkRef CADisplayLink *
#else
#import <CoreGraphics/CGDirectDisplay.h>
#define SADisplayLinkRef CVDisplayLinkRef
#endif

@interface SAAnimationLayer : CALayer

@property (copy, nonatomic)     NSArray             *properties;    // [key:NSString*, min:NSNumber*]...

@property (copy, nonatomic)     void (^drawBlock)(SAAnimationLayer *layer, CGContextRef ctx);
@property (copy, nonatomic)     void (^animationCreated)(SAAnimationLayer *layer, CABasicAnimation *anim);

@property (copy, nonatomic)     dispatch_block_t    didStart;
@property (copy, nonatomic)     dispatch_block_t    didStop;

@property (readonly, nonatomic) SADisplayLinkRef    timer;

+ (SAAnimationLayer *)layer:(NSArray *)properties;

- (CGFloat)getProperty:(NSString *)key;
- (void)setProperty:(CGFloat)value key:(NSString *)key;

@end
