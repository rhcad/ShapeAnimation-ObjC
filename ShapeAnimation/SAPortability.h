//
//  SAPortability.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/24.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>
#define SAView                  UIView
#define SAImage                 UIImage
#define SAFont                  UIFont
#define SAColor                 UIColor
#define kSACGColorBlack         UIColor.blackColor.CGColor
#define SAGestureRecognizer     UIGestureRecognizer
#define SATapRecognizer         UITapGestureRecognizer
#define SAPanRecognizer         UIPanGestureRecognizer
#define SAGesturePossible       UIGestureRecognizerStatePossible
#define SAGestureBegan          UIGestureRecognizerStateBegan
#define SAGestureChanged        UIGestureRecognizerStateChanged
#define SAGestureEnded          UIGestureRecognizerStateEnded
#define SAButton                UIButton
#define SASetButtonAction(button, target_, action_) \
    [button addTarget:target_ action:action_ forControlEvents:UIControlEventTouchUpInside]
#else

#import <Cocoa/Cocoa.h>
#define SAView                  NSView
#define SAImage                 NSImage
#define SAFont                  NSFont
#define SAColor                 NSColor
#define kSACGColorBlack         CGColorGetConstantColor(kCGColorBlack)
#define SAGestureRecognizer     NSGestureRecognizer
#define SATapRecognizer         NSClickGestureRecognizer
#define SAPanRecognizer         NSPanGestureRecognizer
#define SAGesturePossible       NSGestureRecognizerStatePossible
#define SAGestureBegan          NSGestureRecognizerStateBegan
#define SAGestureChanged        NSGestureRecognizerStateChanged
#define SAGestureEnded          NSGestureRecognizerStateEnded
#define SAButton                NSButton
#define SASetButtonAction(button, target_, action_) \
    button.target = target_; button.action = action_

@interface NSValue (CGPoint)
+ (NSValue *)valueWithCGPoint:(CGPoint)point;
- (CGPoint)CGPointValue;
@end

#endif
