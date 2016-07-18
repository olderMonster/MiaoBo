//
//  MBHomeHotCell.m
//  MiaoBo
//
//  Created by kehwa on 16/7/7.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeHotCell.h"
#import "OMNetworkingConfiguration.h"
#import <UIImageView+WebCache.h>
@interface MBHomeHotCell()

@property (nonatomic , strong)UIImageView *avatarImageView; //头像
@property (nonatomic , strong)UILabel *nickNameLabel;       //昵称
@property (nonatomic , strong)UIImageView *levelImageView;  //星级
@property (nonatomic , strong)UIImageView *locationImageView;  //城市图标
@property (nonatomic , strong)UILabel *locationLabel;          //城市
@property (nonatomic , strong)UILabel *onLineLabel;            //在线人数
@property (nonatomic , strong)UIImageView *liveImageView;      //直播图片
@property (nonatomic , strong)UIImageView *isLivingImageView;  //是否在直播
@property (nonatomic , strong)UIView *sepView;

@end

@implementation MBHomeHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.levelImageView];
        [self.contentView addSubview:self.locationImageView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.onLineLabel];
        [self.contentView addSubview:self.liveImageView];
        [self.contentView addSubview:self.isLivingImageView];
        [self.contentView addSubview:self.sepView];
    }
    return self;
}


- (void)setLiveDict:(NSDictionary *)liveDict{
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:liveDict[@"smallpic"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nickNameLabel.text = liveDict[@"myname"];
    
    self.locationLabel.text = liveDict[@"gps"];
    
    NSString *onLiveCount = [NSString stringWithFormat:@"%@人在看",liveDict[@"allnum"]];
    NSRange range = [onLiveCount rangeOfString:[NSString stringWithFormat:@"%@",liveDict[@"allnum"]]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:onLiveCount];
    [attrStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:RGB(216, 41, 116)} range:range];
    self.onLineLabel.attributedText = attrStr;
    
    NSString *levelStr = [NSString stringWithFormat:@"girl_star%@_40x19",liveDict[@"starlevel"]];
    self.levelImageView.image = [UIImage imageNamed:levelStr];
    
    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:liveDict[@"bigpic"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    self.avatarImageView.frame = CGRectMake(10, 10, 30, 30);
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width * 0.5;
    
    self.liveImageView.frame = CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame) + 10, kScreenWidth, kScreenWidth);
    
    CGSize nickNameSize = [self.nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nickNameLabel.font}];
    self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, 10, nickNameSize.width, nickNameSize.height);
    
    self.levelImageView.bounds = CGRectMake(0, 0, 40, 19);
    self.levelImageView.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 10 + self.levelImageView.bounds.size.width * 0.5, self.nickNameLabel.center.y);
    
    self.locationImageView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMaxY(self.nickNameLabel.frame) + 5, 8, 8);
    
    CGSize locationSize = [self.locationLabel.text sizeWithAttributes:@{NSFontAttributeName:self.locationLabel.font}];
    self.locationLabel.bounds = CGRectMake(0, 0, locationSize.width, locationSize.height);
    self.locationLabel.center = CGPointMake(CGRectGetMaxX(self.locationImageView.frame) + 10 + locationSize.width * 0.5, self.locationImageView.center.y);

    CGSize onLineSize = [self.onLineLabel.text sizeWithAttributes:@{NSFontAttributeName:self.onLineLabel.font}];
    self.onLineLabel.bounds = CGRectMake(0, 0, onLineSize.width, onLineSize.height);
    self.onLineLabel.center = CGPointMake(kScreenWidth  - onLineSize.width*0.5, self.avatarImageView.center.y);
    
    self.isLivingImageView.bounds = CGRectMake(0, 0, 43, 22);
    self.isLivingImageView.center = CGPointMake(kScreenWidth - 10 - self.isLivingImageView.bounds.size.width * 0.5,self.liveImageView.frame.origin.y + 10 + self.isLivingImageView.bounds.size.height * 0.5);
    
    self.sepView.frame = CGRectMake(0, CGRectGetMaxY(self.liveImageView.frame), kScreenWidth, 10);
}

#pragma mark - getters and setters
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.borderColor = RGB(216, 41, 116).CGColor;
        _avatarImageView.layer.borderWidth = 1.0f;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel{
    if (_nickNameLabel == nil) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.backgroundColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickNameLabel;
}

- (UIImageView *)levelImageView{
    if (_levelImageView == nil) {
        _levelImageView = [[UIImageView alloc]init];
    }
    return _levelImageView;
}

- (UIImageView *)locationImageView{
    if (_locationImageView == nil) {
        _locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_location_8x8"]];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.backgroundColor = [UIColor whiteColor];
        _locationLabel.font = [UIFont systemFontOfSize:11];
        _locationLabel.textColor = [UIColor grayColor];
    }
    return _locationLabel;
}

- (UILabel *)onLineLabel{
    if (_onLineLabel == nil) {
        _onLineLabel = [[UILabel alloc]init];
        _onLineLabel.backgroundColor = [UIColor clearColor];
        _onLineLabel.font = [UIFont systemFontOfSize:14];
        _onLineLabel.textColor = [UIColor grayColor];
    }
    return _onLineLabel;
}

- (UIImageView *)liveImageView{
    if (_liveImageView == nil) {
        _liveImageView = [[UIImageView alloc]init];
    }
    return _liveImageView;
}

- (UIImageView *)isLivingImageView{
    if (_isLivingImageView == nil) {
        _isLivingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_live_43x22"]];
    }
    return _isLivingImageView;
}

- (UIView *)sepView{
    if (_sepView == nil) {
        _sepView = [[UIView alloc]init];
        _sepView.backgroundColor = RGB(235, 235, 243);
    }
    return _sepView;
}

@end
