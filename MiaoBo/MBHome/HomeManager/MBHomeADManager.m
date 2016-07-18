//
//  PDAdManager.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/18.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeADManager.h"

@implementation MBHomeADManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark -- PDApiManager
- (NSString *)methodName{
    return @"Living/GetAD";
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
