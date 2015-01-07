//
//  NSUserDefaults+Preferences.h
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#define kPreferencesAutoProgressDifficulty @"kPreferencesAutoProgressDifficulty"
#define kPreferencesRotationEnabled @"kPreferencesRotationEnabled"
#define kPreferencesPreferedDifficulty @"kPreferencesPreferedDifficulty"

#define kNotificationPreferencesChanged @"kNotificationPreferencesChanged"

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Preferences)

- (void)setAutoprogressDifficulty:(BOOL)autoprogress;
- (BOOL)autoProgressDifficultyEnabled;

- (void)setRotationEnabled:(BOOL)enabled;
- (BOOL)rotationEnabled;

- (void)setPreferedDifficulty:(NSInteger)dificulty;
- (NSInteger)preferedDifficulty;

@end
