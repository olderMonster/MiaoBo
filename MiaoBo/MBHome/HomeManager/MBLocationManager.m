//
//  MBLocationManager.m
//  MiaoBo
//
//  Created by kehwa on 16/7/15.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBLocationManager.h"
#import <UIKit/UIKit.h>

NSString * const MBLocationManagerDidSuccessedLocateNotification = @"MBLocationManagerDidSuccessedLocateNotification";
NSString * const MBLocationManagerDidFailedLocateNotification = @"MBLocationManagerDidFailedLocateNotification";
NSString * const MBLocationManagerDidSwitchCityNotification = @"MBLocationManagerDidSwitchCityNotification";

@interface MBLocationManager()<CLLocationManagerDelegate>

@property (nonatomic , strong)CLLocationManager *locationManager;

@property (nonatomic , strong , readwrite)CLLocation *locatedCityLocation;

@property (nonatomic , readwrite)MBLocationManagerLocationResult locationResult;
@property (nonatomic , readwrite)MBLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic , copy, readwrite)NSString *methodName;
@property (nonatomic ,strong)NSString *serviceType;

@end

@implementation MBLocationManager
@synthesize methodName = _methodName;
@synthesize serviceType= _serviceType;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.locationResult = MBLocationManagerLocationResultDefault;
        self.locationStatus = MBLocationManagerLocationServiceStatusDefault;
        
        
        _methodName = @"_methodName";
        _serviceType = kMBService;
        
        self.callBackDelegate = self;
        self.sourceDelegate = self;
        self.validator = self;
        
    }
    return self;
}
#pragma mark - public method
- (void)startLocatiton{
    if ([self checkLocationAndShowingAlert:NO]) {
        self.locationResult = MBLocationManagerLocationResultLocating;
        [self.locationManager startUpdatingLocation];
    }else{
        [self failedLocatioWithResultType:MBLocationManagerLocationResultFailure statusType:self.locationStatus];
    }
}

- (void)stopLocation{
    if ([self checkLocationAndShowingAlert:NO]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (BOOL)checkLocationAndShowingAlert:(BOOL)showAlert{
    BOOL result = NO;
    //定位服务是否可用
    BOOL serviceEnable = [self locationServiceEnabled];
    //用户授权状态
    MBLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == MBLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }else if (authorizationStatus == MBLocationManagerLocationServiceStatusNotDermined){
        result = YES;
    }else{
        result = NO;
    }
    
    
    if (serviceEnable && result) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocatioWithResultType:MBLocationManagerLocationResultFailure statusType:self.locationStatus];
    }
    
    if (showAlert && result == NO) {
        NSString *message = @"请到“设置->隐私->定位服务”中开启定位";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:cancel];
        [alert addAction:ok];
        [alert showViewController:[UIApplication sharedApplication].keyWindow.rootViewController sender:nil];
    }
    return result;
}

#pragma mark -- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)location{

    //一开始启动的时候会跑到这边4次。所以如果以后的坐标都不变的话，后面的逻辑也就没必要再跑了。
    if (manager.location.coordinate.latitude == self.locatedCityLocation.coordinate.latitude && manager.location.coordinate.latitude == self.locatedCityLocation.coordinate.longitude) {
        return;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    //之前如果有定位成功,以后的定位失败都不通知外面
    
    
    
    //如果用户还没有选择是否允许定位,则不认为定位失败
    if (self.locationStatus == MBLocationManagerLocationServiceStatusNotDermined) {
        return;
    }
    
    //如果正在定位中,也不会通知外面
    if (self.locationResult == MBLocationManagerLocationResultLocating) {
        return;
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBLocationManagerDidFailedLocateNotification object:nil userInfo:nil];
    
}


#pragma mark - private method
- (BOOL)locationServiceEnabled{
    if (([CLLocationManager locationServicesEnabled])) {
        self.locationStatus = MBLocationManagerLocationServiceStatusOK;
        return YES;
    }else{
        self.locationStatus = MBLocationManagerLocationServiceStatusUnknowError;
        return NO;
    }
}

//用户授权状态
- (MBLocationManagerLocationServiceStatus)locationServiceStatus{
    self.locationStatus = MBLocationManagerLocationServiceStatusUnknowError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = MBLocationManagerLocationServiceStatusNotDermined;
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                self.locationStatus = MBLocationManagerLocationServiceStatusOK;
                break;
            case kCLAuthorizationStatusDenied:
                self.locationStatus = MBLocationManagerLocationServiceStatusNoAuthorization;
                break;
            default:
                if (![self isReachable]) {
                    self.locationStatus = MBLocationManagerLocationServiceStatusNoNetwork;
                }
                break;
        }
    }else{
        self.locationStatus = MBLocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

- (void)failedLocatioWithResultType:(MBLocationManagerLocationResult)result statusType:(MBLocationManagerLocationServiceStatus)status{
    self.locationResult = result;
    self.locationStatus = status;
    
}

- (void)fetchCityInfoWithLocation:(CLLocation *)location{
    self.locatedCityLocation = location;
    self.locationResult = MBLocationManagerLocationResultSuccess;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBLocationManagerDidSuccessedLocateNotification object:self userInfo:nil];
    
}

#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    //留给将来使用API的时候用
    return nil;
}

#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    //留给将来使用API的时候用
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    //留给将来使用API的时候用
    return YES;
}


#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    //留给将来使用API的时候用
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    //留给将来使用API的时候用
}


#pragma mark - getters and setters
- (CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

@end
