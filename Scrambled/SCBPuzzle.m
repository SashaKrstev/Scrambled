//
//  SCBPuzzleContainer.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#define kExceptionPileUp @"kExceptionPileUp"

#import "SCBPuzzle.h"

#import "SCBPuzzleTile.h"
#import "SCBFrameProvider.h"
#import <Masonry/Masonry.h>
#import "NSUserDefaults+Preferences.h"

@implementation SCBPuzzle
{
    NSArray *frameValues;
    NSMutableArray *tiles;
    CGRect sourceFrame;
    NSMutableArray *currentTileState;
    BOOL gestureInProgress;
}

- (instancetype)init
{
    self = [self initWithLevel:1];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithLevel:(NSInteger)level
{
    self = [super init];
    if (self)
    {
        gestureInProgress = NO;
        self.currentLevel = level;
        tiles = [NSMutableArray new];
        currentTileState = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Tear down and build up

- (void)tearDown
{
    for (SCBPuzzleTile* tile in tiles)
    {
        [tile removeFromSuperview];
    }
    [tiles removeAllObjects];
}

- (void)animateTeardownWithCompletion:(SCBCompletionBlock)completion
{
    [UIView animateWithDuration:0.5 delay:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        for (SCBPuzzleTile* tile in tiles)
        {
            tile.transform = CGAffineTransformMakeTranslation(1000, 0);
        }
    } completion:^(BOOL finished) {
        [self tearDown];
        if (completion) {
            completion();
        }
    }];
}

- (void)buildup
{
    frameValues = [SCBFrameProvider generateFramesForLevel:_currentLevel inFrame:self.bounds];
    for (NSValue* frameValue in frameValues)
    {
        SCBPuzzleTile* tile = [[SCBPuzzleTile alloc] initWithFrame: frameValue.CGRectValue];
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        panRecognizer.delegate = self;
        [tile addGestureRecognizer: panRecognizer];
        
        UITapGestureRecognizer *rotationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        rotationGesture.delegate = self;
        rotationGesture.numberOfTapsRequired = 2;
        rotationGesture.enabled = [[NSUserDefaults standardUserDefaults] rotationEnabled];
        [tile addGestureRecognizer:rotationGesture];
        
        [tiles addObject: tile];
        [self addSubview:tile];
    }
}

- (void)animateBuildupWithCompletion:(SCBCompletionBlock)completion
{
    [self buildup];
    float ratio = self.image.size.height / self.frame.size.height;
    for (SCBPuzzleTile* tile in tiles)
    {
        [tile setImage: [self imageByCroppingImage:self.image withRect:[self multiplyRect:tile.frame withfloat:ratio]]];
    }
    [self scramlbe];

    for (SCBPuzzleTile* tile in tiles)
    {
        float delay = (320-(tile.frame.origin.x+tile.frame.size.width+640))/640.0;
        if ([[NSUserDefaults standardUserDefaults] rotationEnabled]) {
            [tile rotateTile:arc4random() % 4];
        }

        __block CGRect fromFrame = tile.frame;
        tile.frame = CGRectOffset(fromFrame, -640, 0);
        [UIView animateWithDuration:0.25
                              delay:delay
                            options:(UIViewAnimationOptionCurveEaseIn)
                         animations:^{
                             tile.frame = CGRectOffset(fromFrame, -10, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                             animations:^{
                                 tile.frame = fromFrame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }];
    }
}

#pragma mark - Internal Methods

- (void)scramlbe
{
    NSMutableArray* temp = [frameValues mutableCopy];
    NSMutableArray* temp2 = [NSMutableArray new];
    
    for (int i = 0; i < frameValues.count; i++)
    {
        id obj = temp[arc4random()%temp.count];
        [temp2 addObject:obj];
        [temp removeObject:obj];
    }
    if ([temp2 isEqualToArray:frameValues]) {
        NSLog(@"scramble failed, trying again");
        [self scramlbe];
        return;
    }
    int i = 0;
    for (SCBPuzzleTile* tile in tiles)
    {
        tile.frame = ((NSValue*)temp2[i]).CGRectValue;
        i++;
    }
    [self saveCurrentTileState];
}

- (UIImage *)imageByCroppingImage:(UIImage *)image withRect:(CGRect)cropRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (CGRect)multiplyRect:(CGRect)rect withfloat:(float)multiplier
{
    CGRect result;
    
    result.origin.x = rect.origin.x*multiplier;
    result.origin.y = rect.origin.y*multiplier;
    result.size.width = rect.size.width*multiplier;
    result.size.height = rect.size.height*multiplier;
    
    return result;
}

- (CGPoint)addPoint:(CGPoint)point1 withPoint:(CGPoint)point2
{
    return CGPointMake(point1.x+point2.x, point1.y+point2.y);
}

- (void)checkAllFrames
{
    BOOL correct = YES;
    for (SCBPuzzleTile* tile in tiles)
    {
        if (!tile.isInPlace) {
            correct = NO;
            break;
        }
    }
    
    if (correct)
    {
        if ([self.delegate respondsToSelector:@selector(puzzleSuccessfulyCompleted:)]) {
            [self.delegate puzzleSuccessfulyCompleted:self];
        }
    }
}

- (void)verifyFrameAligment
{
    for (int i = 0; i < tiles.count; i++) {
        SCBPuzzleTile *tile1 = tiles[i];
        for (int j = i+1; j < tiles.count; j++) {
            SCBPuzzleTile *tile2 = tiles[j];
            CGRect frame1 = tile1.frame;
            CGRect frame2 = tile2.frame;
            CGRect intersection = CGRectIntersection(frame1, frame2);
            if (CGRectGetHeight(intersection) != 0 && CGRectGetWidth(intersection) != 0) {
                NSLog(@"Thorwing exception");
                NSException *exception = [NSException exceptionWithName:kExceptionPileUp
                                                                 reason:@"More than one tile occupies a given frame"
                                                               userInfo:@{}];
                @throw exception;
            }
        }
    }
}

- (void)saveCurrentTileState
{
    [currentTileState removeAllObjects];
    for (SCBPuzzleTile *tile in tiles) {
        [currentTileState addObject:[NSValue valueWithCGRect:tile.frame]];
    }
}

- (void)restoreTileState
{
    int i = 0;
    for (SCBPuzzleTile *tile in tiles) {
        NSValue *frameValue = currentTileState[i];
        tile.frame = frameValue.CGRectValue;
        i++;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!gestureInProgress) {
        gestureInProgress = YES;
        return gestureInProgress;
    }
    return !gestureInProgress;
}

- (void)onDoubleTap:(UITapGestureRecognizer *)gesture
{
    SCBPuzzleTile *tile = (SCBPuzzleTile *)gesture.view;
    [UIView animateWithDuration:0.25 animations:^{
        [tile rotateTile];
    } completion:^(BOOL finished) {
        [self checkAllFrames];
    }];
}

- (void)onPan:(UIPanGestureRecognizer*)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            sourceFrame = gesture.view.frame;
            [self bringSubviewToFront:gesture.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self];
            gesture.view.frame = CGRectOffset(sourceFrame, translation.x, translation.y);
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            gesture.view.frame = sourceFrame;
            gestureInProgress = NO;
            break;
        case UIGestureRecognizerStateRecognized:
        {
            BOOL shouldSwap = NO;
            SCBPuzzleTile* sourceTile;
            CGPoint translation = [gesture locationInView:self];
            
            for (SCBPuzzleTile* destinationTile in tiles)
            {
                if (destinationTile != gesture.view &&
                    (CGRectContainsPoint(destinationTile.frame, translation))
                    )
                {
                    shouldSwap = YES;
                    sourceTile = destinationTile;
                    break;
                }
            }
            if (shouldSwap)
            {
  
                [UIView animateWithDuration:0.25 animations:^{
                    gesture.view.frame = sourceTile.frame;
                    sourceTile.frame = sourceFrame;
                } completion:^(BOOL finished) {
                    @try {
                        NSLog(@"animation finished %d",finished);
                        [self verifyFrameAligment];
                    }
                    @catch (NSException *exception) {
                        [self restoreTileState];
                    }
                    [self checkAllFrames];
                }];
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    gesture.view.frame = sourceFrame;
                }];
            }
            gestureInProgress = NO;
        }
            break;
        default:
            gesture.view.frame = sourceFrame;
            gestureInProgress = NO;
            break;
    }
}

@end
