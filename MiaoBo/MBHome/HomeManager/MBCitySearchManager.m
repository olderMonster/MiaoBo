//
//  MBCitySearchManager.m
//  MiaoBo
//
//  Created by kehwa on 16/7/18.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBCitySearchManager.h"

@implementation MBCitySearchManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark -- PDApiManager
- (NSString *)methodName{
    return @"Room/GetHotCity";
}

- (NSString *)serviceType{
    return kMBService;
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}


#pragma mark -- PDApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    return YES;
}


@end
