//
//  SCBFrameProvider.h
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCBFrameProvider : NSObject

/**
 * Returns an Array of NSValues containing CGRects
 * The CGRects fill the given frame divided by level
 */
+ (NSArray *)generateFramesForLevel:(NSInteger)level inFrame:(CGRect)frame;

@end
