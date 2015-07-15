//
//  CALayer+Slide.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/25.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAAnimationPair.h"

@interface CALayer (Slide)

- (SAAnimationPair *)slideToRight;
- (SAAnimationPair *)slideAnimation:(NSString *)subtype;

- (SAAnimationPair *)flipHorizontally;
- (SAAnimationPair *)flipVertically;

- (SAAnimationPair *)transformAnimation:(CATransform3D)to;
- (SAAnimationPair *)transformAnimation:(CATransform3D)from to:(CATransform3D)to;

@end
