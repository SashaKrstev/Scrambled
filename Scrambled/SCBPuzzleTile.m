//
//  SCBPuzzleTile.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import "SCBPuzzleTile.h"
@interface SCBPuzzleTile ()
{
    CGRect originalFrame;
    NSInteger rotation;
}
@property (nonatomic, readwrite) BOOL isInPlace;

@end

@implementation SCBPuzzleTile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        originalFrame = frame;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        rotation = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateInPlace];
}

- (void)rotateTile
{
    [self rotateTile:rotation + 1];
}

- (void)rotateTile:(NSInteger)steps
{
    NSInteger rotationStep = steps % 4;
    NSLog(@"rotationStep %d", rotationStep);
    CGRect startingFrame = self.frame;
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    switch (rotationStep) {
        case 1:
            rotationTransform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case 2:
            rotationTransform = CGAffineTransformMakeRotation(M_PI);
            break;
        case 3:
            rotationTransform = CGAffineTransformMakeRotation(M_PI_2 * 3);
            break;
    }
    self.transform = rotationTransform;
    self.frame = startingFrame;
    rotation = rotationStep;
    [self updateInPlace];
}

- (void)updateInPlace
{
    self.isInPlace = [self frame:self.frame isEqualToFrame:originalFrame] && rotation == 0;
}

- (BOOL)frame:(CGRect)rect1 isEqualToFrame:(CGRect)rect2
{
    return rect1.origin.x == rect2.origin.x &&
    rect1.origin.y == rect2.origin.y &&
    rect1.size.width == rect2.size.width &&
    rect1.size.height == rect2.size.height;
}

@end
