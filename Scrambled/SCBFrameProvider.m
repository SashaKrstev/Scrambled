//
//  SCBFrameProvider.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import "SCBFrameProvider.h"

@implementation SCBFrameProvider

+ (NSArray *)generateFramesForLevel:(NSInteger)level inFrame:(CGRect)frame;
{
    NSMutableArray *result = [NSMutableArray new];
    
    [self splitFrame:frame withLevel:level intoArray:result];
    
    return [result copy];
}

+ (void)splitFrame:(CGRect)rect withLevel:(NSInteger)level intoArray:(NSMutableArray *)result
{
    if (rect.size.width > 2*rect.size.height) {
        [self splitFrameVertical:rect withLevel:level intoArray:result];
    } else if (rect.size.height > 2*rect.size.width) {
        [self splitFrameHorizontal:rect withLevel:level intoArray:result];
    } else {
        if (arc4random()%2)
            [self splitFrameHorizontal:rect withLevel:level intoArray:result];
        else
            [self splitFrameVertical:rect withLevel:level intoArray:result];
    }
}

+ (void)splitFrameVertical:(CGRect)rect withLevel:(NSInteger)level intoArray:(NSMutableArray *)result
{
    if (level > 0) {
        CGRect rect1;
        CGRect rect2;
        
        rect1 = CGRectMake(rect.origin.x+rect.size.width/2.0, rect.origin.y,
                           rect.size.width/2.0, rect.size.height);
        rect2 = CGRectMake(rect.origin.x, rect.origin.y,
                           rect.size.width/2.0, rect.size.height);
        BOOL lr = arc4random()%2;
        float ceiling = ceilf((level-1)/2.0);
        float flooring = floorf((level-1)/2.0);
        
        [self splitFrame:rect1 withLevel:lr?ceiling:flooring intoArray:result];
        [self splitFrame:rect2 withLevel:lr?flooring:ceiling intoArray:result];
    } else {
        [result addObject:[NSValue valueWithCGRect:rect]];
    }
}

+ (void)splitFrameHorizontal:(CGRect)rect withLevel:(NSInteger)level intoArray:(NSMutableArray *)result
{
    if (level > 0) {
        CGRect rect1;
        CGRect rect2;
        
        rect1 = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2.0,
                           rect.size.width, rect.size.height/2.0);
        rect2 = CGRectMake(rect.origin.x, rect.origin.y,
                           rect.size.width, rect.size.height/2.0);
        BOOL lr = arc4random()%2;
        float ceiling = ceilf((level-1)/2.0);
        float flooring = floorf((level-1)/2.0);
        
        [self splitFrame:rect1 withLevel:lr?ceiling:flooring intoArray:result];
        [self splitFrame:rect2 withLevel:lr?flooring:ceiling intoArray:result];
    } else {
        [result addObject:[NSValue valueWithCGRect:rect]];
    }
}

@end
