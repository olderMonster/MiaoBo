//
//  MBNewController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBNewController.h"
#import "OMNetworkingConfiguration.h"

#import "MBHomeNewManager.h"

#import "MBHomeNewCell.h"

@interface MBNewController ()<UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate>

@property (nonatomic , strong)UICollectionView *newestCollectionView;

@property (nonatomic , strong)NSMutableArray *newestLiveTable;

@property (nonatomic , strong)MBHomeNewManager *newestManager;

@end

@implementation MBNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.newestCollectionView];
    
    [self.newestManager loadData];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.newestCollectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 44 - 20);
}

#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}
#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    NSDictionary *dict = [manager fetchDataWithReformer:nil];
    self.newestLiveTable = [NSMutableArray arrayWithArray:dict[@"data"][@"list"]];
    [self.newestCollectionView reloadData];
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newestLiveTable.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBHomeNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.liveDict = self.newestLiveTable[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 2) / 3, (kScreenWidth - 2) / 3);
}


#pragma mark - getters and setters
- (UICollectionView *)newestCollectionView{
    if (_newestCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        
        _newestCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _newestCollectionView.backgroundColor = [UIColor whiteColor];
        _newestCollectionView.dataSource = self;
        _newestCollectionView.delegate = self;
        [_newestCollectionView registerClass:[MBHomeNewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _newestCollectionView;
}

- (MBHomeNewManager *)newestManager{
    if (_newestManager == nil) {
        _newestManager = [[MBHomeNewManager alloc]init];
        _newestManager.sourceDelegate = self;
        _newestManager.callBackDelegate = self;
    }
    return _newestManager;
}

- (NSMutableArray *)newestLiveTable{
    if (_newestLiveTable == nil) {
        _newestLiveTable = [NSMutableArray array];
    }
    return _newestLiveTable;
}

@end
