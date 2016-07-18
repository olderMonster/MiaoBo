//
//  OMSegmentedControl.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,OMSegmentedControlMode) {
    OMSegmentedControlModeNormal,  //正常模式，两端按钮呈现为方角[][][]
    OMSegmentedControlModeFillet ,  //圆角模式，按钮呈现为圆角()()()
    OMSegmentedControlModeOuterFillet, //半圆角模式，第一个按钮的左边为圆角，最后一个按钮的右边为圆角 (][][)
    OMSegmentedControlModeSwipe //底部标识滑动模式
};

@protocol OMSegmentedControlDelegate <NSObject>

@optional
- (void)didSelectSegmentIndex:(NSInteger)segmentIndex;

@end


@interface OMSegmentedControl : UIView

@property (nonatomic , assign)OMSegmentedControlMode segmentMode;

//@property (nonatomic , assign , readonly)NSInteger currentSelectedSegmentIndex;

@property (nonatomic , assign)NSInteger selectedSegmentIndex;
@property (nonatomic , strong)UIColor *normalTextColor;
@property (nonatomic , strong)UIColor *selectedTextColor;

@property (nonatomic , strong)UIImage *normalBackgroundImage;
@property (nonatomic , strong)UIImage *selectedBackgroundImage;

@property (nonatomic , strong)UIColor *borderColor;
@property (nonatomic , assign)CGFloat borderWidth;

@property (nonatomic , strong)UIColor *slipeColor;

@property (nonatomic , weak)id<OMSegmentedControlDelegate>segmentControlDelegate;

- (instancetype)initWithItems:(NSArray *)items;
- (void)setNormalBackgroundImage:(UIImage *)backgroundImage segmentIndex:(NSInteger)segmentIndex;
- (void)setSelectedBackgroundImage:(UIImage *)backgroundImage segmentIndex:(NSInteger)segmentIndex;

@end
