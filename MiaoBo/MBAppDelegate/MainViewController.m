//
//  MainViewController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MainViewController.h"
#import "MBHomeController.h"
#import "MBUserController.h"
#import "OMNetworkingConfiguration.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //排行榜:http://live.9158.com/Rank/WeekRank?Random=10
    
    //热搜主播:http://live.9158.com/Room/GetRandomAnchor?useridx=61411649
    //热搜城市:http://live.9158.com/Room/GetHotCity
    //我的喵币-国内支付:http://live.9158.com/pay/index/?platform=2&typeId=3
    //直播间管理:http://live.9158.com/Room/GetMyLiveRoom?useridx=61411649
    
    //关于喵播-用户协议:http://live.9158.com/Content/Css/protocol.css
    //关于喵播-主播规范:http://live.9158.com/about/AnchorAgreeMent?Random=8
    //关于喵播-用户主播政策:http://live.9158.com/about/privacy?Random=0
    
    //我的关注:http://live.9158.com/Fans/getMyAllFriendsList
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBarTintColor:RGB(223, 90, 147)];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    MBHomeController *homeVC = [[MBHomeController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"toolbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"toolbar_home_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    MBUserController *userVC = [[MBUserController alloc]init];
    UINavigationController *userNav = [[UINavigationController alloc]initWithRootViewController:userVC];
    userVC.tabBarItem.image = [[UIImage imageNamed:@"toolbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"toolbar_me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.viewControllers = @[homeNav,userNav];
    
}



@end
