//
//  DetailViewController.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "DetailViewController.h"
#import "ShapeAnimation.h"

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.animationBlock) {
        self.animationBlock(self.shapeView);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.animationBlock = nil;
    self.data = nil;
}

- (IBAction)pause:(id)sender {
    self.shapeView.paused = !self.shapeView.paused;
}

@end
