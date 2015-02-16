//
//  SCBPuzzleContainer.h
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCBPuzzleDelegate;

typedef void (^SCBCompletionBlock)(void);

@interface SCBPuzzle : UIView
<
    UIGestureRecognizerDelegate
>

/**
 * Initializes a puzzle with a given level
 */
- (id)initWithLevel:(NSInteger)level;

/**
 * Tears down the current puzzle with animation
 * completion called when animation is finished
 */
- (void)animateTeardownWithCompletion:(SCBCompletionBlock)completion;

/**
 * Builds up a new puzzle with animation
 * completion called when animation is finished
 */
- (void)animateBuildupWithCompletion:(SCBCompletionBlock)completion;

/**
 * The current puzzled image
 */
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<SCBPuzzleDelegate> delegate;

/**
 * The current puzzle Level
 */
@property (nonatomic) NSInteger currentLevel;

@end



@protocol SCBPuzzleDelegate <NSObject>

- (void)puzzleSuccessfulyCompleted:(SCBPuzzle *)puzzle;

@end