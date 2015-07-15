//
//  DetailViewController.h
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAShapeView;

typedef void (^AnimationBlock)(SAShapeView *view);

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet SAShapeView *shapeView;
@property (strong, nonatomic) AnimationBlock animationBlock;
@property (strong, nonatomic) NSObject      *data;

- (IBAction)pause:(id)sender;

@end

#define CGColorFromRGBA(r, g, b, a) \
    [UIColor colorWithRed:(float)(r) green:(float)(g) blue:(float)(b) alpha:(float)(a)].CGColor
