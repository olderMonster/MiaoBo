//
//  MBRankController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/15.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBRankController.h"

@interface MBRankController ()

@property (nonatomic , strong)UIWebView *webView;

@end

@implementation MBRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"排行";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -- getters and setters
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc]init];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://live.9158.com/Rank/WeekRank?Random=10"]]];
    }
    return _webView;
}

@end
