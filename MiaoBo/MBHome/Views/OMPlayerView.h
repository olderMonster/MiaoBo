//
//  OMPlayerView.h
//  MiaoBo
//
//  Created by kehwa on 16/7/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMPlayerView : UIView

@property (nonatomic , copy)NSString *urlString;

- (instancetype)initWithUrlString:(NSString *)urlString;

- (void)play;

@end
