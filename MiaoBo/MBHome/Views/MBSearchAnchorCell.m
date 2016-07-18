//
//  MBSearchAnchorCell.m
//  MiaoBo
//
//  Created by kehwa on 16/7/15.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBSearchAnchorCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MBSearchAnchorCell()

@property (nonatomic , strong)UIImageView *avatarImageView;
@property (nonatomic , strong)UIImageView *locationImageView;
@property (nonatomic , strong)UILabel *distanceLabel;

@end

@implementation MBSearchAnchorCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 2;
        [self.contentView addSubview:_avatarImageView];
        
        
        _locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_map_cateid_99"]];
        [self.contentView addSubview:_locationImageView];
        
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.font = [UIFont systemFontOfSize:10];
        _distanceLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_distanceLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.avatarImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    
    self.locationImageView.bounds = CGRectMake(0, 0, 10, 10);
    self.locationImageView.center = CGPointMake(self.locationImageView.bounds.size.width * 0.5, CGRectGetMaxY(self.avatarImageView.frame) + (self.contentView.bounds.size.height - self.avatarImageView.bounds.size.height) * 0.5);
    
    self.distanceLabel.bounds = CGRectMake(0, 0, self.contentView.frame.size.width - (CGRectGetMaxX(self.locationImageView.frame) + 5), self.contentView.frame.size.height - CGRectGetMaxY(self.avatarImageView.frame));
    self.distanceLabel.center = CGPointMake(CGRectGetMaxX(self.locationImageView.frame) + 5 + self.distanceLabel.bounds.size.width * 0.5, self.locationImageView.center.y);
    
}

- (void)setAnchor:(NSDictionary *)anchor{
    _anchor = anchor;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:anchor[@"photo"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    self.distanceLabel.text = anchor[@"position"];
    
}

@end
