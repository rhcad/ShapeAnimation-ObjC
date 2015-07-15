//
//  EllipseViewController.h
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "DetailViewController.h"

@interface EllipseViewController : DetailViewController

@property (weak, nonatomic) IBOutlet UISlider *rxSlider;
@property (weak, nonatomic) IBOutlet UISlider *rySlider;
@property (weak, nonatomic) IBOutlet UISlider *angleSlider;

- (IBAction)radiusXChanged:(UISlider *)sender;
- (IBAction)radiusYChanged:(UISlider *)sender;
- (IBAction)angleChanged:(UISlider *)sender;

@end
