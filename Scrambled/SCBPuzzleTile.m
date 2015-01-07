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
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateInPlace];
}

- (void)updateInPlace
{
    self.isInPlace = [self frame:self.frame isEqualToFrame:originalFrame];
}

- (BOOL)frame:(CGRect)rect1 isEqualToFrame:(CGRect)rect2
{
    return rect1.origin.x == rect2.origin.x &&
    rect1.origin.y == rect2.origin.y &&
    rect1.size.width == rect2.size.width &&
    rect1.size.height == rect2.size.height;
}

@end
