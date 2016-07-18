//
//  MBHomeNewManager.m
//  MiaoBo
//
//  Created by kehwa on 16/7/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeNewManager.h"

@implementation MBHomeNewManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark -- PDApiManager
- (NSString *)methodName{
    return @"Room/GetNewRoomOnline";
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
