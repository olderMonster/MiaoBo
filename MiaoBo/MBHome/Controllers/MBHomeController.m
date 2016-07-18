//
//  MBHomeController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeController.h"
#import "MBHotController.h"
#import "MBNewController.h"
#import "MBFollowController.h"
#import "OMNetworkingConfiguration.h"
#import "OMSegmentedControl.h"
#import "MBRankController.h"
#import "MBSearchController.h"
@interface MBHomeController ()<UIScrollViewDelegate,OMSegmentedControlDelegate>

@property (nonatomic , strong)NSArray *categories;
@property (nonatomic , strong)UIScrollView *homeScrollView;

@property (nonatomic , strong)MBHotController *hotVC;
@property (nonatomic , strong)MBNewController *newestVC;
@property (nonatomic , strong)MBFollowController *followVC;
@property (nonatomic , strong)OMSegmentedControl *segmentedControl;

@end

@implementation MBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.homeScrollView];
    
    [self initTitleView];
    [self initItems];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    self.homeScrollView.frame = self.view.bounds;
    self.homeScrollView.contentSize = CGSizeMake(self.homeScrollView.bounds.size.width * self.categories.count, 0);
    
    self.hotVC.view.frame = CGRectMake(0, 0, self.homeScrollView.bounds.size.width, self.homeScrollView.bounds.size.height);
    self.newestVC.view.frame = CGRectMake(CGRectGetMaxX(self.hotVC.view.frame), 0, self.homeScrollView.bounds.size.width, self.homeScrollView.bounds.size.height);
    self.followVC.view.frame = CGRectMake(CGRectGetMaxX(self.newestVC.view.frame), 0, self.homeScrollView.bounds.size.width, self.homeScrollView.bounds.size.height);
}

#pragma mark - private method
- (void)initTitleView{
    
    self.segmentedControl = [[OMSegmentedControl alloc]initWithItems:self.categories];
    self.segmentedControl.frame = CGRectMake(0, 0, 180, 25);
    self.segmentedControl.segmentMode = OMSegmentedControlModeSwipe;
    self.segmentedControl.normalTextColor = [UIColor whiteColor];
    self.segmentedControl.selectedTextColor = [UIColor whiteColor];
    self.segmentedControl.slipeColor = [UIColor whiteColor];
    self.segmentedControl.segmentControlDelegate = self;
    self.navigationItem.titleView = self.segmentedControl;
}


- (void)initItems{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 24, 24);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"head_crown_24x24"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 17, 17);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"search_15x14"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

}

#pragma mark - event response
- (void)leftBarButtonItemAction{
    self.tabBarController.tabBar.hidden = YES;
    MBSearchController *searchVC = [[MBSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightBarButtonItemAction{
    self.tabBarController.tabBar.hidden = YES;
    MBRankController *rankVC = [[MBRankController alloc]init];
    [self.navigationController pushViewController:rankVC animated:YES];
}

#pragma mark - OMSegmentedControlDelegate
- (void)didSelectSegmentIndex:(NSInteger)segmentIndex{
    
    [self.homeScrollView scrollRectToVisible:CGRectMake(self.homeScrollView.bounds.size.width * segmentIndex, self.homeScrollView.frame.origin.y, self.homeScrollView.bounds.size.width , self.homeScrollView.bounds.size.height ) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.segmentedControl.selectedSegmentIndex = page;
}


#pragma mark - getters and setters
- (UIScrollView *)homeScrollView{
    if (_homeScrollView == nil) {
        _homeScrollView = [[UIScrollView alloc]init];
        _homeScrollView.backgroundColor = [UIColor whiteColor];
        _homeScrollView.bounces = NO;
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        _homeScrollView.showsVerticalScrollIndicator = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.delegate = self;
        
        [_homeScrollView addSubview:self.hotVC.view];
        [_homeScrollView addSubview:self.newestVC.view];
        [_homeScrollView addSubview:self.followVC.view];
    }
    return _homeScrollView;
}


- (MBHotController *)hotVC{
    if (_hotVC == nil) {
        _hotVC = [[MBHotController alloc]init];
    }
    return _hotVC;
}

- (MBNewController *)newestVC{
    if (_newestVC == nil) {
        _newestVC = [[MBNewController alloc]init];
    }
    return _newestVC;
}


- (MBFollowController *)followVC{
    if (_followVC == nil) {
        _followVC = [[MBFollowController alloc]init];
    }
    return _followVC;
}

- (NSArray *)categories{
    if (_categories == nil) {
        _categories = @[@"最热",@"最新",@"关注"];
    }
    return _categories;
}


@end
