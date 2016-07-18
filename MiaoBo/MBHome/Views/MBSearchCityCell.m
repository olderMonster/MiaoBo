//
//  MBSearchCityCell.m
//  MiaoBo
//
//  Created by kehwa on 16/7/18.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBSearchCityCell.h"
#import "OMNetworkingConfiguration.h"
@interface MBSearchCityCell()

@property (nonatomic , strong)UILabel *cityNameLabel;

@end

@implementation MBSearchCityCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _cityNameLabel = [[UILabel alloc]init];
        _cityNameLabel.layer.borderColor = [UIColor grayColor].CGColor;
        _cityNameLabel.layer.borderWidth = 1.0f;
        _cityNameLabel.layer.masksToBounds = YES;
        _cityNameLabel.layer.cornerRadius = 2;
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_cityNameLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.cityNameLabel.frame = self.contentView.bounds;
    
}


- (void)setCity:(NSDictionary *)city{
    _city = city;
    
    self.cityNameLabel.text = city[@"position"];
    
}

@end
