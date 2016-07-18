//
//  MBHotController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHotController.h"

#import <SDCycleScrollView.h>
#import "MBRefreshHeader.h"

#import "MBHomeADManager.h"
#import "MBHomeHotManager.h"

#import "MBHomeHotCell.h"
#import "MBLivingController.h"

@interface MBHotController ()<UITableViewDataSource , UITableViewDelegate , OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate , OMApiManagerInterceptor>

@property (nonatomic , strong)UITableView *hotTableView;
@property (nonatomic , strong)SDCycleScrollView *adScrollView;

@property (nonatomic , strong)MBHomeADManager *adManager;
@property (nonatomic , strong)MBHomeHotManager *hotManager;
@property (nonatomic , strong)NSArray *adGroups;
@property (nonatomic , strong)NSMutableArray *hotLiveTable;

@end

@implementation MBHotController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hotTableView];
    self.hotTableView.tableHeaderView = self.adScrollView;
    
    [self.adManager loadData];
    
    [self addRefreshAction];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.hotTableView.frame = self.view.bounds;
    
}

#pragma mark - http request
- (void)addRefreshAction{
    self.hotTableView.mj_header = [MBRefreshHeader headerWithRefreshingTarget:self.hotManager refreshingAction:@selector(loadFirstPage)];
    [self.hotTableView.mj_header beginRefreshing];
}


#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}

#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    
    if ([manager isKindOfClass:[MBHomeADManager class]]) {
        
        NSDictionary *dict = [manager fetchDataWithReformer:nil];
        
        self.adGroups = dict[@"data"];
        NSMutableArray *adUrlStringGroups = [NSMutableArray array];
        for (NSDictionary *dict in self.adGroups) {
            [adUrlStringGroups addObject:dict[@"imageUrl"]];
        }
        self.adScrollView.imageURLStringsGroup = adUrlStringGroups;
        
    }
    
    if ([manager isKindOfClass:[MBHomeHotManager class]]) {
        
        NSDictionary *resDict = [manager fetchDataWithReformer:nil];
        if (self.hotManager.page == 2) {
            self.hotLiveTable = [NSMutableArray arrayWithArray:resDict[@"data"][@"list"]];
        }else{
            [self.hotLiveTable addObjectsFromArray:resDict[@"data"][@"list"]];
        }
        
        [self.hotTableView reloadData];
    }
    

}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    switch (manager.errorType) {
        case OMAPIManagerErrorTypeDefault:
            NSLog(@"默认错误");
            break;
        case OMAPIManagerErrorTypeSuccess:
            NSLog(@"请求成功");
            break;
        case OMAPIManagerErrorTypeNoContent:
            NSLog(@"验证函数返回NO");
            break;
        case OMAPIManagerErrorTypeParamsError:
            NSLog(@"参数错误");
            break;
        case OMAPIManagerErrorTypeTimeout:
            NSLog(@"超时错误");
            break;
        case OMAPIManagerErrorTypeNoNetWork:
            NSLog(@"无网络");
            break;
        default:
            break;
    }
}

#pragma mark - OMApiManagerInterceptor
- (void)manager:(OMBaseApiManager *)manager afterCallingApiWithParams:(NSDictionary *)params{
    NSInteger page = [params[@"page"] integerValue];
    if (page == 1) {
        [self.hotTableView.mj_header endRefreshing];
    }else{
        [self.hotTableView.mj_footer endRefreshing];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotLiveTable.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    MBHomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MBHomeHotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.liveDict = self.hotLiveTable[indexPath.section];
    if (indexPath.section == self.hotLiveTable.count - 5) {
        [self.hotManager loadNextPage];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MBLivingController *livingVC = [[MBLivingController alloc]init];
    livingVC.allAnchorTable = self.hotLiveTable;
    livingVC.currentAnchorIndex = indexPath.section;
    [self presentViewController:livingVC animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 + kScreenWidth + 10;
}


#pragma mark - getters and setters
- (UITableView *)hotTableView{
    if (_hotTableView == nil) {
        _hotTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hotTableView.backgroundColor = [UIColor whiteColor];
        _hotTableView.dataSource = self;
        _hotTableView.delegate = self;
        _hotTableView.tableFooterView = [[UIView alloc]init];
        _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hotTableView.showsVerticalScrollIndicator = NO;
    }
    return _hotTableView;
}
- (SDCycleScrollView *)adScrollView{
    if (_adScrollView == nil) {
        _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 100) delegate:nil placeholderImage:[UIImage imageNamed:@"defaultlivebg"]];
        _adScrollView.autoScrollTimeInterval = 3.0;
    }
    return _adScrollView;
}


- (MBHomeADManager *)adManager{
    if (_adManager == nil) {
        _adManager = [[MBHomeADManager alloc]init];
        _adManager.sourceDelegate = self;
        _adManager.callBackDelegate = self;
    }
    return _adManager;
}
- (NSArray *)adGroups{
    if (_adGroups == nil) {
        _adGroups = [[NSArray alloc]init];
    }
    return _adGroups;
}

- (MBHomeHotManager *)hotManager{
    if (_hotManager == nil) {
        _hotManager = [[MBHomeHotManager alloc]init];
        _hotManager.sourceDelegate = self;
        _hotManager.callBackDelegate = self;
        _hotManager.interceptor = self;
    }
    return _hotManager;
}
- (NSMutableArray *)hotLiveTable{
    if (_hotLiveTable == nil) {
        _hotLiveTable = [NSMutableArray array];
    }
    return _hotLiveTable;
}

@end
