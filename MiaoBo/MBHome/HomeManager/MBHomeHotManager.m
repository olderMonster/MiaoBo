//
//  MBHomeHotManager.m
//  MiaoBo
//
//  Created by kehwa on 16/7/7.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBHomeHotManager.h"

@interface MBHomeHotManager()

@property (nonatomic , assign , readwrite)NSInteger page;

@end

@implementation MBHomeHotManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.page = 1;
        self.validator = self;
    }
    return self;
}

- (void)beforePerformSuccessWithResponse:(OMApiResponse *)response{
    self.page ++;
}

- (void)beforePerformFailureWithResponse:(OMApiResponse *)response{
    if (self.page > 0) {
        self.page --;
    }
}

#pragma mark - public method
- (void)loadFirstPage{
    self.page = 1;
    [self loadData];
}


- (void)loadNextPage{
    if (self.isLoading) {
        return;
    }
    
    [self loadData];
}



#pragma mark -- PDApiManager
- (NSString *)methodName{
    return @"Fans/GetHotLive";
}

- (NSString *)serviceType{
    return kMBService;
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}

- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSMutableDictionary *apiParams = [NSMutableDictionary dictionaryWithDictionary:params];
    apiParams[@"page"] = @(self.page);
    return apiParams;
}


#pragma mark -- PDApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    return YES;
}

@end
