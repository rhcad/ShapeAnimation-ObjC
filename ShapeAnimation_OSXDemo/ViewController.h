//
//  ViewController.h
//  ShapeAnimation_OSXDemo
//
//  Created by Zhang Yungui on 15/3/9.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SAShapeView;

@interface ViewController : NSViewController

@property (strong) IBOutlet SAShapeView *shapeView;

@end

#define CGColorFromRGBA(r, g, b, a) \
    [NSColor colorWithDeviceRed:(float)(r) green:(float)(g) blue:(float)(b) alpha:(float)(a)].CGColor