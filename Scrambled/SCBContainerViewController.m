//
//  ViewController.m
//  Scrambled
//
//  Created by Sasha on 1/7/15.
//  Copyright (c) 2015 Sasha. All rights reserved.
//

#import "SCBContainerViewController.h"
#import "SCBSettingsViewController.h"
#import <Masonry/Masonry.h>

@interface SCBContainerViewController ()

@end

@implementation SCBContainerViewController

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

#pragma mark - Actions

- (void)onSettingsButton:(UIButton *)sender
{
    
}

@end
