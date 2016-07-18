//
//  MBLivingUserViewCell.m
//  MiaoBo
//
//  Created by kehwa on 16/7/14.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBLivingUserViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MBLivingUserViewCell()

@property (nonatomic , strong)UIImageView *avatarImageView;
@property (nonatomic , strong)UIImageView *levelImageView;

@end

@implementation MBLivingUserViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        _levelImageView = [[UIImageView alloc]init];
        _levelImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_levelImageView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _avatarImageView.frame = self.bounds;
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.height * 0.5;
    
    CGFloat R = self.frame.size.width * 0.5;
    CGFloat r = R * (1 - cos(M_PI_4));
    
    _levelImageView.bounds = CGRectMake(0, 0, 2*r, 2*r);
    _levelImageView.center = CGPointMake(R*(1 + cos(M_PI_4)), R*(1 + cos(M_PI_4)));
    
}

- (void)setAnchorInfo:(NSDictionary *)anchorInfo{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:anchorInfo[@"smallpic"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
}

@end
