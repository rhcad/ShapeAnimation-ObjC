//
//  PointTests.m
//  ShapeAnimation_OSXTests
//
//  Created by Zhang Yungui on 15/3/10.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ShapeAnimation.h"

@interface PointTests : XCTestCase

@end

#define XCTAssertEqualPoint(a, b) XCTAssertEqualWithAccuracy(SAPointDistance(a, b), 0, FLT_EPSILON)

@implementation PointTests

- (void)testRulerPoint {
    XCTAssertEqualPoint(SAPointAdd(CGPointMake(4,2), CGPointMake(2,1)), CGPointMake(6,3));
    XCTAssertEqualPoint(SAPointSubtract(CGPointMake(4,2), CGPointMake(2,1)), CGPointMake(2,1));
    
    XCTAssertEqualPoint(SAPointWithAngleLength(M_PI_4, 2), CGPointMake(M_SQRT2, M_SQRT2));
    XCTAssertEqualPoint(SAPointWithPolar(CGPointMake(5,4), M_PI_4, 2), CGPointMake(5+M_SQRT2, 4+M_SQRT2));
    
    CGPoint p0 = CGPointMake(5+4, 4+3);
    XCTAssertEqualPoint(SAPointWithRulerX(CGPointMake(5,4), p0, 5), p0);
    CGPoint p1 = SAPointWithRulerY(CGPointMake(5,4), p0, 3);
    XCTAssertEqualWithAccuracy(SAPointDistance(p1, CGPointMake(5,4)), 3, FLT_EPSILON);
    CGPoint p2 = SAPointWithRuler(CGPointMake(5,4), p0, 5, 3);
    XCTAssertEqualWithAccuracy(SAPointDistance(p0, p2), SAPointDistance(p0, CGPointMake(5+4,4)), FLT_EPSILON);
}

- (void)testPathLength {
    XCTAssertEqualWithAccuracy(SAPathLength(CGPathFromSVGPath(@"M0,0L4,3")), 5, FLT_EPSILON);
    
    CGPoint pts[13];
    SABeziersFromEllipse(pts, CGPointZero, 5, 5);
    XCTAssertEqualWithAccuracy(SABeziersLength(pts, 13), 10 * M_PI, 0.01);
}

@end
