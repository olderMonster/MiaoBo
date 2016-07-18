//
//  MBSearchController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/15.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBSearchController.h"
#import "OMSegmentedControl.h"
#import "OMNetworkingConfiguration.h"

#import "MBLocationManager.h"
#import "MBAnchorSearchManager.h"
#import "MBCitySearchManager.h"

#import "MBSearchAnchorCell.h"
#import "MBSearchCityCell.h"

NSString *const kAnchorCellIdentifier = @"kAnchorCellIdentifier";
NSString *const kAnchorHeaderIdentifier = @"kAnchorHeaderIdentifier";

NSString *const kCityCellIdentifier = @"kCityCellIdentifier";
NSString *const kCityHeaderIdentifier = @"kCityHeaderIdentifier";

@interface MBSearchController ()<UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , OMSegmentedControlDelegate , UIScrollViewDelegate , OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate>

@property (nonatomic , strong)OMSegmentedControl *segmentControl;
@property (nonatomic , strong)UIScrollView *searchScrollView;
@property (nonatomic , strong)UICollectionView *anchorCollectionView;
@property (nonatomic , strong)UICollectionView *cityCollectionView;

@property (nonatomic , strong)MBLocationManager *locateManager;
@property (nonatomic , strong)MBAnchorSearchManager *anchorManager;
@property (nonatomic , strong)MBCitySearchManager *cityManager;


@property (nonatomic , strong)NSArray *anchorTable;
@property (nonatomic , strong)NSArray *cityTable;

@end

@implementation MBSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserLication:) name:MBLocationManagerDidSuccessedLocateNotification object:nil];
    
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.searchScrollView];
    
//    [self.locateManager startLocatiton];
    
    
    [self.anchorManager loadData];
    [self.cityManager loadData];

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.segmentControl.frame = CGRectMake(0, 64, kScreenWidth, 30);
    self.searchScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), kScreenWidth, self.view.bounds.size.height - CGRectGetMaxY(self.segmentControl.frame));
    self.searchScrollView.contentSize = CGSizeMake(kScreenWidth * 2, self.searchScrollView.bounds.size.height);
    self.anchorCollectionView.frame = CGRectMake(0, 0, self.searchScrollView.bounds.size.width,self.searchScrollView.bounds.size.height);
    self.cityCollectionView.frame = CGRectMake(CGRectGetMaxX(self.anchorCollectionView.frame), 0, self.searchScrollView.bounds.size.width,self.searchScrollView.bounds.size.height);
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}


#pragma mark - event response
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.segmentControl.selectedSegmentIndex = page;
}


//- (void)getUserLication:(NSNotification *)noticifation{
//    CLLocation *location = self.locateManager.locatedCityLocation;
//    NSLog(@"旧的经度：%f,旧的纬度：%f",location.coordinate.longitude,location.coordinate.latitude);
//}

#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}


#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    NSDictionary *dict = [manager fetchDataWithReformer:nil];
    if (manager == self.anchorManager) {
        self.anchorTable = dict[@"data"];
        [self.anchorCollectionView reloadData];
    }
    if (manager == self.cityManager) {
        self.cityTable = dict[@"data"];
        [self.cityCollectionView reloadData];
    }
    
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}

#pragma mark - OMSegmentedControlDelegate
- (void)didSelectSegmentIndex:(NSInteger)segmentIndex{
    
    //通过scrollRectToVisible设置滚动时contentSize中的值不能为0,否则该方法无效
    [self.searchScrollView scrollRectToVisible:CGRectMake(self.searchScrollView.bounds.size.width * segmentIndex, self.searchScrollView.frame.origin.y, self.searchScrollView.bounds.size.width, self.searchScrollView.bounds.size.height) animated:YES];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.anchorCollectionView) {
        return self.anchorTable.count;
    }
    return self.cityTable.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.anchorCollectionView) {
        MBSearchAnchorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAnchorCellIdentifier forIndexPath:indexPath];
        cell.anchor = self.anchorTable[indexPath.row];
        return  cell;
        
    }else{
        
        MBSearchCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCityCellIdentifier forIndexPath:indexPath];
        cell.city = self.cityTable[indexPath.row];
        return  cell;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView;

    if (kind == UICollectionElementKindSectionHeader) {
        if (collectionView == self.anchorCollectionView) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kAnchorHeaderIdentifier forIndexPath:indexPath];
        }
        if (collectionView == self.cityCollectionView) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCityHeaderIdentifier forIndexPath:indexPath];
        }
        
        reusableView.backgroundColor = RGB(235, 235, 241);
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(10, 0, reusableView.frame.size.width - 20, reusableView.frame.size.height);
        titleLabel.frame = reusableView.bounds;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = collectionView == self.anchorCollectionView?@"   热搜主播":@"   热搜城市";
        titleLabel.textColor = [UIColor grayColor];
        [reusableView addSubview:titleLabel];
        
    }
    
    return  reusableView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.anchorCollectionView) {
        return CGSizeMake((collectionView.bounds.size.width - 10 - 20) / 3, (collectionView.bounds.size.width - 10) / 3 + 15);
    }
    return CGSizeMake((collectionView.bounds.size.width - 40) / 3, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.anchorCollectionView) {
        return 5;
    }
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.anchorCollectionView) {
        return 5;
    }
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 40);
}


#pragma mark - getters and setters
- (OMSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        _segmentControl = [[OMSegmentedControl alloc]initWithItems:@[@"用户",@"城市"]];
        _segmentControl.selectedTextColor = RGB(223, 90, 147);
        _segmentControl.segmentMode = OMSegmentedControlModeSwipe;
        _segmentControl.slipeColor = RGB(223, 90, 147);
        _segmentControl.segmentControlDelegate = self;
    }
    return _segmentControl;
}

- (UIScrollView *)searchScrollView{
    if (_searchScrollView == nil) {
        _searchScrollView = [[UIScrollView alloc]init];
        _searchScrollView.backgroundColor = [UIColor whiteColor];
        _searchScrollView.pagingEnabled = YES;
        _searchScrollView.showsHorizontalScrollIndicator = NO;
        _searchScrollView.showsVerticalScrollIndicator = NO;
        _searchScrollView.bounces = NO;
        _searchScrollView.delegate = self;
        
        [_searchScrollView addSubview:self.anchorCollectionView];
        [_searchScrollView addSubview:self.cityCollectionView];
    }
    return _searchScrollView;
}

- (UICollectionView *)anchorCollectionView{
    if (_anchorCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _anchorCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _anchorCollectionView.backgroundColor = RGB(235, 235, 241);
        _anchorCollectionView.dataSource = self;
        _anchorCollectionView.delegate = self;
        [_anchorCollectionView registerClass:[MBSearchAnchorCell class] forCellWithReuseIdentifier:kAnchorCellIdentifier];
        [_anchorCollectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAnchorHeaderIdentifier];
    }
    return _anchorCollectionView;
}

- (UICollectionView *)cityCollectionView{
    if (_cityCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _cityCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _cityCollectionView.backgroundColor = RGB(235, 235, 241);
        _cityCollectionView.dataSource = self;
        _cityCollectionView.delegate = self;
        [_cityCollectionView registerClass:[MBSearchCityCell class] forCellWithReuseIdentifier:kCityCellIdentifier];
        [_cityCollectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCityHeaderIdentifier];
    }
    return _cityCollectionView;
}



- (MBLocationManager *)locateManager{
    if (_locateManager == nil) {
        _locateManager = [[MBLocationManager alloc]init];
    }
    return _locateManager;
}

- (MBAnchorSearchManager *)anchorManager{
    if (_anchorManager == nil) {
        _anchorManager = [[MBAnchorSearchManager alloc]init];
        _anchorManager.sourceDelegate = self;
        _anchorManager.callBackDelegate = self;
    }
    return _anchorManager;
}

- (MBCitySearchManager *)cityManager{
    if (_cityManager == nil) {
        _cityManager = [[MBCitySearchManager alloc]init];
        _cityManager.sourceDelegate = self;
        _cityManager.callBackDelegate = self;
    }
    return _cityManager;
}


- (NSArray *)anchorTable{
    if (_anchorTable == nil) {
        _anchorTable = [[NSArray alloc]init];
    }
    return _anchorTable;
}

- (NSArray *)cityTable{
    if (_cityTable == nil) {
        _cityTable = [[NSArray alloc]init];
    }
    return _cityTable;
}

@end
