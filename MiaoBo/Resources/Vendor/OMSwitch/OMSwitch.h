//
//  OMSwitch.h
//  MiaoBo
//
//  Created by kehwa on 16/7/13.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMSwitch;

@protocol OMSwitchDelegate <NSObject>

@optional
- (void)didClickSwitch:(OMSwitch *)switchControl status:(BOOL)status;

@end

@interface OMSwitch : UIView

//选中时的文本
@property (nonatomic , copy)NSString *selectedText;
//关闭（未选中）的文本
@property (nonatomic , copy)NSString *unselectedText;

//选中时的文本颜色
@property (nonatomic , strong)UIColor *selectedTextColor;
//关闭（未选中）的文本颜色
@property (nonatomic , strong)UIColor *unselectedTextColor;

//选中时的背景颜色
@property (nonatomic , strong)UIColor *selectedBgColor;
//关闭（未选中）的背景颜色
@property (nonatomic , strong)UIColor *unselectedBgColor;

//当前Switch的状态
@property (nonatomic , assign)BOOL isOpen;


@property (nonatomic , weak)id<OMSwitchDelegate>delegate;

@end
