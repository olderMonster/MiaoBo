//
//  MBHomeNewCell.m
//  MiaoBo
//
//  Created by kehwa on 16/7/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeNewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MBHomeNewCell()

@property (nonatomic , strong)UIImageView *liveImageView;

@end

@implementation MBHomeNewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _liveImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_liveImageView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _liveImageView.frame = self.contentView.bounds;
    
}

- (void)setLiveDict:(NSDictionary *)liveDict{
    [_liveImageView sd_setImageWithURL:[NSURL URLWithString:liveDict[@"photo"]] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
}


@end
