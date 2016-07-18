//
//  UIView+HandleAddition.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "UIView+HandleAddition.h"

@implementation UIView (HandleAddition)

- (void)drawFilletLeft:(BOOL)isLeftFillet right:(BOOL)isRightFillet{
    if (!(isLeftFillet && isRightFillet)) {
        UIBezierPath *maskPath;
        if (isLeftFillet) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
        }
        if (isRightFillet) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
        }
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }

}

@end
