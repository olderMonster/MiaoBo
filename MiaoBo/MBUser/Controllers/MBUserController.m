//
//  MNUserController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBUserController.h"
#import "OMNetworkingConfiguration.h"
@interface MBUserController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong)UITableView *userTableView;

@property (nonatomic , strong)NSArray *userTable;


@end

@implementation MBUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userTableView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.userTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.userTable.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userTable[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.userTable[indexPath.section][indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -- getters and setters
- (UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _userTableView.backgroundColor = RGB(235, 235, 241);
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        _userTableView.tableFooterView = [[UIView alloc]init];
    }
    return _userTableView;
}

- (NSArray *)userTable{
    if (_userTable == nil) {
        _userTable = @[@[@"我的喵币",@"直播间管理"],@[@"我的收益",@"微钱进理财"],@[@"设置"]];
    }
    return _userTable;
}

@end
