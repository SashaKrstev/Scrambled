//
//  NSUserDefaults+Preferences.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#define kPreferencesAutoProgressDifficulty @"kPreferencesAutoProgressDifficulty"
#define kPreferencesRotationEnabled @"kPreferencesRotationEnabled"
#define kPreferencesPreferedDifficulty @"kPreferencesPreferedDifficulty"

#import "NSUserDefaults+Preferences.h"

@implementation NSUserDefaults (Preferences)

- (void)setAutoprogressDifficulty:(BOOL)autoprogress
{
    [[NSUserDefaults standardUserDefaults] setObject:@(autoprogress) forKey:kPreferencesAutoProgressDifficulty];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)autoProgressDifficultyEnabled
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kPreferencesAutoProgressDifficulty] boolValue];
}

- (void)setRotationEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setObject:@(enabled) forKey:kPreferencesRotationEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)rotationEnabled
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kPreferencesRotationEnabled] boolValue];
}

- (void)setPreferedDifficulty:(NSInteger)dificulty
{
    [[NSUserDefaults standardUserDefaults] setObject:@(dificulty) forKey:kPreferencesPreferedDifficulty];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSInteger)preferedDifficulty
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kPreferencesRotationEnabled] integerValue];
}

@end
