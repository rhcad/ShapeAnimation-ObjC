//
//  SAShapeView+Pause.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/26.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "SAShapeView.h"


@interface SAShapeView (Pause)

@property (nonatomic) BOOL paused;

- (void)stopAnimations;

@end
