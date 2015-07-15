//
//  SearchMenuAnimation.h
//  ShapeAnimation_iOSDemo
//
//  Created by Zhang Yungui on 15/3/12.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "ShapeAnimation.h"

@interface SearchMenuTextField : UITextField<UITextFieldDelegate>

@property (weak, nonatomic) UIButton  *srearchButton;

- (void)tapViewToHidden:(id)view;

@end
