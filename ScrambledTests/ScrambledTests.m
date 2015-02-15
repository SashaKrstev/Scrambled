//
//  ScrambledTests.m
//  ScrambledTests
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SCBFrameProvider.h"
#import "NSUserDefaults+Preferences.h"

@interface ScrambledTests : XCTestCase

@end

@implementation ScrambledTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFrames
{
    for (int i = 0; i< MAX_LEVEL; i++) {
        NSArray *frames = [SCBFrameProvider generateFramesForLevel:i inFrame:CGRectZero];
        XCTAssertEqual(frames.count, i+1);
        for (NSValue *frameValue1 in frames) {
            for (NSValue *frameValue2 in frames) {
                CGRect frame1 = frameValue1.CGRectValue;
                CGRect frame2 = frameValue2.CGRectValue;
                CGRect intersection = CGRectIntersection(frame1, frame2);
                XCTAssertEqual(intersection.origin.x, 0);
                XCTAssertEqual(intersection.origin.y, 0);
                XCTAssertEqual(intersection.size.width, 0);
                XCTAssertEqual(intersection.size.height, 0);
            }
        }
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
       [SCBFrameProvider generateFramesForLevel:MAX_LEVEL inFrame:CGRectZero];
    }];
}

@end
