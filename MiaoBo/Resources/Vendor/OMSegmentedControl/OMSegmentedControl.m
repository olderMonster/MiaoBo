//
//  OMSegmentedControl.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMSegmentedControl.h"
#import "UIView+HandleAddition.h"
@interface OMSegmentedControl()

@property (nonatomic , strong)NSMutableArray *items;
@property (nonatomic , strong)UIButton *lastSelectedButton;

@property (nonatomic , strong)UIView *slipeView;

@end

@implementation OMSegmentedControl

- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor colorWithRed:250.0/255.0 green:181.0/255.0 blue:54.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 0.5f;
        
        if (items.count) {
            for (int index = 0 ; index < items.count; index ++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                button.backgroundColor = [UIColor colorWithRed:0/250.0 green:143/255.0 blue:237/255.0 alpha:1.0];
                [button setTitle:items[index] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:253/255.0 green:240/255.0 blue:211/255.0 alpha:1.0]] forState:UIControlStateNormal];
                [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:250.0/250.0 green:181.0/255.0 blue:54.0/255.0 alpha:1.0]] forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.tag = index;
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                
                //默认选中第一个item
                if (index == 0) {
                    button.selected = YES;
                    self.lastSelectedButton = button;
                }
                
                
                [self.items addObject:button];
                
            }
        }
        
        NSString *maxLengthString = nil;
        for (NSString *text in items) {
            maxLengthString = text.length > maxLengthString.length?text:maxLengthString;
        }
        
        CGSize maxSize = [maxLengthString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        
        _slipeView = [[UIView alloc]init];
        _slipeView.bounds = CGRectMake(0, 0, maxSize.width + 10, 2);
        _slipeView.backgroundColor = [UIColor redColor];
        _slipeView.hidden = YES;
        [self addSubview:_slipeView];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    if (self.items.count) {
        CGFloat buttonW = self.frame.size.width / self.items.count;
        for (int index = 0; index  < self.items.count; index++) {
            
            UIButton *button = (UIButton *)self.items[index];
            button.frame = CGRectMake(buttonW * index, 0, buttonW, self.frame.size.height);
        }
        
        
        if (self.slipeView.bounds.size.width - 10 > buttonW) {
            self.slipeView.bounds = CGRectMake(0, 0, buttonW, self.slipeView.bounds.size.height);
        }
        self.slipeView.center = CGPointMake(buttonW * 0.5, self.frame.size.height - self.slipeView.bounds.size.height * 0.5);
    }
    
    
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}




- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

- (void)setSegmentMode:(OMSegmentedControlMode)segmentMode{
    
    _segmentMode = segmentMode;
    
    if (self.items.count >=2) {
        
        if (segmentMode == OMSegmentedControlModeNormal){  //正常模式
            UIButton *firstButton = (UIButton *)self.items[0];
            UIButton *lastButton = (UIButton *)self.items.lastObject;
            
            firstButton.layer.masksToBounds = NO;
            lastButton.layer.masksToBounds = NO;
        }
        
        if (segmentMode == OMSegmentedControlModeFillet) { //圆角模式
//            UIButton *firstButton = (UIButton *)self.items[0];
//            UIButton *lastButton = (UIButton *)self.items.lastObject;
//            
//            firstButton.layer.masksToBounds = YES;
//            firstButton.layer.cornerRadius = self.frame.size.height * 0.5;
//            
//            lastButton.layer.masksToBounds = YES;
//            lastButton.layer.cornerRadius = self.frame.size.height * 0.5;
            
            for (UIView *view in self.subviews) {
                
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)view;
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = self.frame.size.height * 0.5;
                }
                
            }
            
            
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = self.frame.size.height * 0.5;
            
        }
        
        //半圆角模式
        if (segmentMode == OMSegmentedControlModeOuterFillet) {
            
//            UIButton *firstButton = (UIButton *)self.items[0];
//            UIButton *lastButton = (UIButton *)self.items.lastObject;
            
//            [firstButton drawFilletLeft:YES right:NO];
//            [lastButton drawFilletLeft:NO right:YES];
            
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = self.frame.size.height * 0.5;
        }
        
        
        if (segmentMode == OMSegmentedControlModeSwipe) {
            
            self.slipeView.hidden = NO;
            
            self.backgroundColor = [UIColor clearColor];
            self.layer.masksToBounds = NO;
            self.layer.cornerRadius = self.frame.size.height;
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0;
            
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)view;
                    if (self.normalTextColor) {
                        [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
                        [button setTitleColor:self.normalTextColor forState:UIControlStateSelected];
                    }
                    if (self.normalBackgroundImage) {
                        [button setBackgroundImage:self.normalBackgroundImage forState:UIControlStateNormal];
                        [button setBackgroundImage:self.normalBackgroundImage forState:UIControlStateSelected];
                    }else{
                        [button setBackgroundImage:nil forState:UIControlStateNormal];
                        [button setBackgroundImage:nil forState:UIControlStateSelected];
                    }

                }
            }
            
        }
        
        
    }
}

- (void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor;
    
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}


- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    
    _selectedSegmentIndex = selectedSegmentIndex;
    
    if ([self itemIsValid:selectedSegmentIndex]) {
        UIButton *button = (UIButton *)self.items[selectedSegmentIndex];
        [self buttonAction:button];
    }
}

- (void)setNormalTextColor:(UIColor *)normalTextColor{
    
    _normalTextColor = normalTextColor;
    
    if (self.items.count) {
        for (UIButton *button in self.items) {
            [button setTitleColor:normalTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor{
    
    _selectedTextColor = selectedTextColor;
    
    if (self.items.count) {
        for (UIButton *button in self.items) {
            [button setTitleColor:selectedTextColor forState:UIControlStateSelected];
        }
    }
}

- (void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage{
    
    _normalBackgroundImage = normalBackgroundImage;
    
    if (self.items.count) {
        for (UIButton *button in self.items) {
            [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage{
    
    _selectedBackgroundImage = selectedBackgroundImage;
    
    if (self.items.count) {
        for (UIButton *button in self.items) {
            [button setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
        }
    }
}


- (void)setSlipeColor:(UIColor *)slipeColor{
    _slipeColor = slipeColor;
    
    self.slipeView.backgroundColor = slipeColor;
}

#pragma mark -- public method
- (void)setNormalBackgroundImage:(UIImage *)backgroundImage segmentIndex:(NSInteger)segmentIndex{
    if ([self itemIsValid:segmentIndex]) {
        UIButton *button = (UIButton *)self.items[segmentIndex];
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}

- (void)setSelectedBackgroundImage:(UIImage *)backgroundImage segmentIndex:(NSInteger)segmentIndex{
    if ([self itemIsValid:segmentIndex]) {
        UIButton *button = (UIButton *)self.items[segmentIndex];
        [button setBackgroundImage:backgroundImage forState:UIControlStateSelected];
    }
}


#pragma mark -- event response
- (void)buttonAction:(UIButton *)button{
    self.lastSelectedButton.selected = NO;
    button.selected = YES;
    self.lastSelectedButton = button;
    
    if (self.segmentMode == OMSegmentedControlModeSwipe) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.slipeView.center = CGPointMake(button.center.x, self.slipeView.center.y);
        }];
        
    }

    if ([self.segmentControlDelegate respondsToSelector:@selector(didSelectSegmentIndex:)]) {
        [self.segmentControlDelegate didSelectSegmentIndex:button.tag];
    }
    
}


#pragma mark -- private method
//颜色值转图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//判断传入的item的index是否有效
- (BOOL)itemIsValid:(NSInteger)segmentIndex{
    if (segmentIndex >= 0 && self.items.count > 0 && segmentIndex < self.items.count){
        return YES;
    }
    return NO;
}

@end
