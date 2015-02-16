//
//  SCBPuzzleTile.h
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBPuzzleTile : UIImageView

/**
 * Rotates the tile to the next step
 */
- (void)rotateTile;

/**
 * Rotates the tile for the given number of steps
 */
- (void)rotateTile:(NSInteger)steps;

/**
 * Checks if the tile is in the right place
 * Checks for frames and transforms
 */
@property (nonatomic, readonly) BOOL isInPlace;

@end
