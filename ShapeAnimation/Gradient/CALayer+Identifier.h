//
//  CALayer+Identifier.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface CALayer (Identifier)

@property (copy, nonatomic)     NSString            *identifier;

- (void)enumerateLayers:(void (^)(CALayer *))block;

@end


typedef void (^SALayerTap)(CALayer *);

@interface CALayer (Tap)

@property (copy, nonatomic)     SALayerTap          didTap;

@end
