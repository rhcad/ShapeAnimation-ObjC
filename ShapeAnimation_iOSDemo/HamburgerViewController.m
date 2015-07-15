//
//  HamburgerViewController.m
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/3/12.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "HamburgerButton.h"
#import "SearchMenuAnimation.h"

@interface HamburgerViewController : UIViewController {
    __weak IBOutlet HamburgerButton *hamburgerButton_;
    __weak IBOutlet SearchMenuTextField *searchMenuTextField_;
}

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SASetButtonAction(hamburgerButton_, self, @selector(toggleHamburger:));
    [searchMenuTextField_ tapViewToHidden:self.view];
}

- (IBAction)toggleHamburger:(id)sender {
}

@end
