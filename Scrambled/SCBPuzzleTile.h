//
//  SCBPuzzleTile.h
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBPuzzleTile : UIImageView

- (void)rotateTile;

- (void)rotateTile:(NSInteger)steps;

@property (nonatomic, readonly) BOOL isInPlace;

@end
