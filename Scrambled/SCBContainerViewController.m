//
//  ViewController.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import "SCBContainerViewController.h"
#import "SCBSettingsViewController.h"
#import "SCBPuzzle.h"
#import <Masonry/Masonry.h>
#import "NSUserDefaults+Preferences.h"

#define NUMBER_OF_IMAGES 389

@interface SCBContainerViewController ()
<
    SCBPuzzleDelegate
>
{
    SCBPuzzle *puzzle;
    UIView *youwinview;
    NSMutableArray *allImageNames;
}
@end

@implementation SCBContainerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPreferencesChangedNotification:) name:kNotificationPreferencesChanged object:nil];
        allImageNames = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImage];
    
    UIView *bottomBar = [UIView new];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    
    UIButton *settingsButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:(UIControlStateNormal)];
    settingsButton.adjustsImageWhenDisabled = YES;
    [settingsButton addTarget:self action:@selector(onSettingsButton:) forControlEvents:(UIControlEventTouchUpInside)];
    settingsButton.adjustsImageWhenDisabled = NO;
    [bottomBar addSubview:settingsButton];

    youwinview = [UIView new];
    youwinview.backgroundColor = [UIColor whiteColor];
    [youwinview addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onYouWinTap:)]];
    youwinview.hidden = YES;
    [self.view addSubview: youwinview];
    
    puzzle = [[SCBPuzzle alloc] initWithLevel:[[NSUserDefaults standardUserDefaults] preferedDifficulty]];
    puzzle.delegate = self;
    [self.view addSubview:puzzle];
    
    [puzzle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(bottomBar.mas_top);
    }];

    [youwinview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(puzzle);
    }];
    
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(settingsButton.mas_width);
        make.height.equalTo(bottomBar);
        make.centerY.equalTo(bottomBar);
        make.right.equalTo(bottomBar).offset(-5.0);
    }];
    
    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!puzzle.image) {
        [self showNextImage];
    }
}

#pragma mark - Actions

- (void)onSettingsButton:(UIButton *)sender
{
    SCBSettingsViewController *settingsVC = [SCBSettingsViewController new];
    UINavigationController *navWrap = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:navWrap animated:YES completion:nil];
}

- (void)onYouWinTap:(id)sender
{
    [self showNextImage];
}

#pragma mark - Notifications

- (void)onPreferencesChangedNotification:(NSNotification *)notification
{
    youwinview.hidden = YES;
    puzzle.currentLevel = [[NSUserDefaults standardUserDefaults] preferedDifficulty];
    [puzzle animateTeardownWithCompletion:^{
        [puzzle animateBuildupWithCompletion:nil];
    }];
}

#pragma mark - SCBPuzzleDelegate

- (void)puzzleSuccessfulyCompleted:(SCBPuzzle *)puzzle
{
    [self flashYouWin];
}

#pragma mark - Internal methods

- (void)showNextImage
{
    if (allImageNames.count == 0) {
        [self buildUpImageArray];
    }
    
    NSString *imageName;
    @try {
        imageName = allImageNames[arc4random() % allImageNames.count];
    }
    @catch (NSException *exception) {
        [self showNextImage];
        return;
    }
    @finally {
        [allImageNames removeObject:imageName];
    }
    UIImage* image = [UIImage imageNamed:imageName];
    if (!image)
    {
        [self showNextImage];
        NSLog(@"failed loading image %@",imageName);
    } else {
        NSLog(@"using image %@",imageName);
        NSLog(@"images left %d %@",allImageNames.count,allImageNames);
        [puzzle animateTeardownWithCompletion:^{
            if ([[NSUserDefaults standardUserDefaults]autoProgressDifficultyEnabled]) {
                puzzle.currentLevel += 1;
            }

            puzzle.image = [UIImage imageNamed:imageName];
            
            [puzzle animateBuildupWithCompletion:^{
                youwinview.hidden = YES;
            }];
        }];
    }
}

- (void)buildUpImageArray
{
    [allImageNames removeAllObjects];
    for(int i = 0; i <= NUMBER_OF_IMAGES; i++) {
        [allImageNames addObject:[NSString stringWithFormat:@"%d.jpg",i]];
    }
}

- (void)flashYouWin
{
    youwinview.hidden = NO;
    [self.view bringSubviewToFront:youwinview];
    [UIView animateWithDuration:0.25 animations:^{
        youwinview.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            youwinview.alpha = 0.1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
