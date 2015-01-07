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

- (id)initWithLevel:(NSInteger)level;

- (void)animateTeardownWithCompletion:(SCBCompletionBlock)completion;

- (void)animateBuildupWithCompletion:(SCBCompletionBlock)completion;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<SCBPuzzleDelegate> delegate;

@property (nonatomic) NSInteger currentLevel;

@end



@protocol SCBPuzzleDelegate <NSObject>

- (void)puzzleSuccessfulyCompleted:(SCBPuzzle *)puzzle;

@end