//
//  MBLocationManager.h
//  MiaoBo
//
//  Created by kehwa on 16/7/15.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMBaseApiManager.h"
#import <CoreLocation/CoreLocation.h>

extern NSString * const MBLocationManagerDidSuccessedLocateNotification;
extern NSString * const MBLocationManagerDidFailedLocateNotification;
extern NSString * const MBLocationManagerDidSwitchCityNotification;

typedef NS_ENUM(NSInteger , MBLocationManagerLocationResult) {
    MBLocationManagerLocationResultDefault,         //默认状态
    MBLocationManagerLocationResultLocating,        //定位中
    MBLocationManagerLocationResultSuccess,         //定位成功
    MBLocationManagerLocationResultFailure,         //定位失败
    MBLocationManagerLocationResultParamsError,     //调用API的参数错了
    MBLocationManagerLocationResultTimeOut,         //超时
    MBLocationManagerLocationResultNoNetwork,       //没有网络
    MBLocationManagerLocationResultNoContent,       //API没返回数据或返回数据是错的
};

typedef NS_ENUM(NSInteger , MBLocationManagerLocationServiceStatus) {
    MBLocationManagerLocationServiceStatusDefault,          //默认状态
    MBLocationManagerLocationServiceStatusOK,               //定位功能正常
    MBLocationManagerLocationServiceStatusUnknowError,      //未知错误
    MBLocationManagerLocationServiceStatusUnAvailable,      //定位功能关掉了
    MBLocationManagerLocationServiceStatusNoAuthorization,  //定位功能打开，但是用户不允许使用定位
    MBLocationManagerLocationServiceStatusNoNetwork,        //没有网络
    MBLocationManagerLocationServiceStatusNotDermined       //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

@interface MBLocationManager : OMBaseApiManager<OMApiManager , OMApiManagerValidator , OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate>

@property (nonatomic , strong , readonly)CLLocation *locatedCityLocation;

@property (nonatomic , readonly)MBLocationManagerLocationResult locationResult;
@property (nonatomic , readonly)MBLocationManagerLocationServiceStatus locationStatus;

- (void)startLocatiton;
- (void)stopLocation;

- (BOOL)checkLocationAndShowingAlert:(BOOL)showAlert;

@end
