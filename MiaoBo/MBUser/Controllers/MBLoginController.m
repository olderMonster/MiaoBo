//
//  MBLoginController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBLoginController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MainViewController.h"
@interface MBLoginController ()

@property (nonatomic , strong)MPMoviePlayerController *moviePlayer;

@property (nonatomic , strong)UIButton *loginButton;

@end

@implementation MBLoginController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.loginButton];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.moviePlayer.view.frame = self.view.bounds;
    self.loginButton.frame = CGRectMake(30, self.view.frame.size.height - 90, self.view.frame.size.width - 60, 40);
}


#pragma mark - event response
- (void)loginButtonAction{
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MainViewController alloc]init];
    
}


#pragma mark - getters and setters
- (MPMoviePlayerController *)moviePlayer{
    if (_moviePlayer == nil) {
        BOOL randomNum = arc4random_uniform(10) % 2 == 0;
        NSString *url = randomNum?@"login_video":@"loginmovie";
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:url ofType:@"mp4"]]];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        [_moviePlayer play];
    }
    return _moviePlayer;
}


- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor clearColor];
        [_loginButton setTitle:@"ALin快速通道" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.borderColor = [UIColor yellowColor].CGColor;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
