//
//  MBHomeHotManager.h
//  MiaoBo
//
//  Created by kehwa on 16/7/7.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMBaseApiManager.h"

@interface MBHomeHotManager : OMBaseApiManager<OMApiManager,OMApiManagerValidator>

@property (nonatomic , assign , readonly)NSInteger page;

- (void)loadFirstPage;
- (void)loadNextPage;
@end
