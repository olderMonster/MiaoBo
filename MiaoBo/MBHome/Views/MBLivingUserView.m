//
//  MBLivingUserView.m
//  MiaoBo
//
//  Created by kehwa on 16/7/13.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBLivingUserView.h"
#import <UIImageView+WebCache.h>
#import "OMNetworkingConfiguration.h"
#import "MBLivingUserViewCell.h"
@interface MBLivingUserView()<UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)UIView *userView; //左边视图(放置昵称,头像,人数,关注按钮)
@property (nonatomic , strong)UIImageView *avatarImageView;  //主播头像
@property (nonatomic , strong)UILabel *nickNameLabel;        //主播昵称
@property (nonatomic , strong)UILabel *watchUserNumLabel;    //当前观看人数
@property (nonatomic , strong)UIButton *followButton;        //关注按钮

@property (nonatomic , strong)UICollectionView *otherAnchorCollectionView;

@property (nonatomic , strong)NSArray *allAnchorTable;

@end

@implementation MBLivingUserView

- (instancetype)initWithUser:(NSDictionary *)user allAnchor:(NSArray *)anchor{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _allAnchorTable = anchor;
        
        _userView = [[UIView alloc]init];
        _userView.backgroundColor = RGBA(219, 219, 221, 0.8);
        [self addSubview:_userView];
        
        _avatarImageView = [[UIImageView alloc]init];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user[@"smallpic"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 0.5f;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_userView addSubview:_avatarImageView];
        
        //宽度最多只有屏幕的一半
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.font = [UIFont systemFontOfSize:10];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.text = user[@"myname"];
        [_userView addSubview:_nickNameLabel];
        
        
        _watchUserNumLabel = [[UILabel alloc]init];
        _watchUserNumLabel.text = [NSString stringWithFormat:@"%@人",user[@"allnum"]];
        _watchUserNumLabel.font = [UIFont systemFontOfSize:10];
        _watchUserNumLabel.textColor = [UIColor whiteColor];
        [_userView addSubview:_watchUserNumLabel];
        
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.backgroundColor = RGB(223, 90, 147);
        _followButton.alpha = 0.5;
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _followButton.layer.masksToBounds = YES;
        [_userView addSubview:_followButton];
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _otherAnchorCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _otherAnchorCollectionView.showsHorizontalScrollIndicator = NO;
        _otherAnchorCollectionView.showsVerticalScrollIndicator = NO;
        _otherAnchorCollectionView.backgroundColor = [UIColor clearColor];
        _otherAnchorCollectionView.dataSource = self;
        _otherAnchorCollectionView.delegate = self;
        [_otherAnchorCollectionView registerClass:[MBLivingUserViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_otherAnchorCollectionView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = kScreenWidth;
    [super setFrame:frame];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    _avatarImageView.frame = CGRectMake(5, 5, self.frame.size.height - 10, self.frame.size.height - 10);
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.height * 0.5;
    
    _followButton.bounds = CGRectMake(0, 0, 40, self.frame.size.height - 14);
    
    CGFloat maxTextWidth = (self.frame.size.width - 20)*0.5 - (CGRectGetMaxX(_avatarImageView.frame) + 5) - _followButton.bounds.size.width - 5;
    CGSize nicknameSize = [_nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:_nickNameLabel.font}];
    CGSize numSize = [_watchUserNumLabel.text sizeWithAttributes:@{NSFontAttributeName:_watchUserNumLabel.font}];
    CGFloat nickNameWidth = nicknameSize.width < maxTextWidth?nicknameSize.width:maxTextWidth;
    nickNameWidth = nickNameWidth > numSize.width?nickNameWidth:numSize.width;
    _nickNameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + 5, _avatarImageView.frame.origin.y, nickNameWidth, 10 + 5);
    
    _watchUserNumLabel.frame = CGRectMake(_nickNameLabel.frame.origin.x, CGRectGetMaxY(_avatarImageView.frame) - _watchUserNumLabel.font.pointSize, nickNameWidth, _watchUserNumLabel.font.pointSize);
    
    
    _followButton.center = CGPointMake(CGRectGetMaxX(_watchUserNumLabel.frame) +5 + _followButton.bounds.size.width * 0.5, _avatarImageView.center.y);
    _followButton.layer.cornerRadius = _avatarImageView.bounds.size.height * 0.5;
    
    
    _userView.frame = CGRectMake(10, 0, CGRectGetMaxX(_followButton.frame) + 5, self.frame.size.height);
    _userView.layer.masksToBounds = YES;
    _userView.layer.cornerRadius = self.frame.size.height * 0.5;
    
    _otherAnchorCollectionView.frame = CGRectMake(CGRectGetMaxX(_userView.frame) + 10, 5, self.frame.size.width - 10 - (CGRectGetMaxX(_userView.frame) + 10), 30);
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allAnchorTable.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBLivingUserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.anchorInfo = _allAnchorTable[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


@end
