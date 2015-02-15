//
//  SCBSettingsViewController.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import "SCBSettingsViewController.h"
#import <Masonry/Masonry.h>
#import "NSUserDefaults+Preferences.h"

@interface SCBSettingsViewController ()
{
    UISwitch *rotationSwitch;
    UISwitch *autoProgressSwitch;
    UISlider *difficultySlider;
    UILabel *difficultyLabel;
}
@end

@implementation SCBSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *rotationLabel = [UILabel new];
    rotationLabel.text = @"Rotations enabled";
    [self.view addSubview:rotationLabel];
    
    rotationSwitch = [UISwitch new];
    [self.view addSubview:rotationSwitch];
    
    UILabel *progressLabel = [UILabel new];
    progressLabel.text = @"Auto increase difficulty";
    [self.view addSubview:progressLabel];
    
    autoProgressSwitch = [UISwitch new];
    [self.view addSubview:autoProgressSwitch];
    
    difficultyLabel = [UILabel new];
    [self.view addSubview:difficultyLabel];
    
    difficultySlider = [UISlider new];
    difficultySlider.minimumValue = 1.0;
    difficultySlider.maximumValue = 100.0;
    [difficultySlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:difficultySlider];

    CGFloat leftMargin = 100;
    CGFloat rightMargin = -100;
    CGFloat padding = 20;
    
    [difficultyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.centerY.equalTo(self.view).multipliedBy(0.3);
    }];
    [difficultySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(difficultyLabel);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.right.equalTo(self.view).offset(rightMargin);
    }];
    
    [rotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.top.equalTo(difficultySlider.mas_bottom).offset(padding);
    }];
    [rotationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rotationLabel);
        make.right.equalTo(self.view).offset(rightMargin);
    }];
    
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.top.equalTo(rotationSwitch.mas_bottom).offset(padding);
    }];
    [autoProgressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(progressLabel);
        make.right.equalTo(self.view).offset(rightMargin);
    }];
    
    [self loadPreferences];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 37)];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(onTopLeftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton setTitle:@"Cancel" forState:(UIControlStateNormal)];
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 37)];
    [okButton addTarget:self action:@selector(onTopRightButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [okButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [okButton setTitle:@"Save" forState:(UIControlStateNormal)];
    UIBarButtonItem* ok = [[UIBarButtonItem alloc] initWithCustomView:okButton];
    self.navigationItem.rightBarButtonItem = ok;
}

#pragma mark - Actions

- (void)onTopLeftButton:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTopRightButton:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Saving your preferences will reshuffle your current puzzle!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Got it", nil];
    [alert show];
}
- (void)onSliderValueChanged:(UISlider *)slider
{
    difficultyLabel.text = [NSString stringWithFormat:@"Starting difficulty:   %d", (int)difficultySlider.value];
}

- (void)loadPreferences
{
    [autoProgressSwitch setOn:[[NSUserDefaults standardUserDefaults] autoProgressDifficultyEnabled]];
    [rotationSwitch setOn:[[NSUserDefaults standardUserDefaults] rotationEnabled]];
 
    [difficultySlider setValue:[[NSUserDefaults standardUserDefaults] preferedDifficulty]];
    difficultyLabel.text = [NSString stringWithFormat:@"Starting difficulty:   %d", (int)difficultySlider.value];
}

- (void)savePreferences
{
    [[NSUserDefaults standardUserDefaults] setAutoprogressDifficulty:autoProgressSwitch.isOn];
    [[NSUserDefaults standardUserDefaults] setRotationEnabled:rotationSwitch.isOn];
    [[NSUserDefaults standardUserDefaults] setPreferedDifficulty:(int)difficultySlider.value];
}

#pragma mark - UIALertViewDelegate 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self savePreferences];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPreferencesChanged object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
