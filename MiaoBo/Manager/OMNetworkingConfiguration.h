//
//  PDNetworkingConfiguration.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#ifndef OMNetworkingConfiguration_h
#define OMNetworkingConfiguration_h


//typedef NS_ENUM(NSInteger, PDAppType) {
//    PDAppTypePandaTV,
//    PDAppTypeBroker,
//    PDAppTypeAifang,
//    PDAppTypeErShouFang,
//    PDAppTypeHaozu
//};

typedef NS_ENUM(NSUInteger, PDApiResponseStatus)
{
    PDApiResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
    PDApiResponseStatusErrorTimeout,
    PDApiResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//以6p(414)为标准
#define PDLayout(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width)

/**
 *  颜色值
 */
//透明度为1的颜色值
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//可设置透明度的颜色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//通用颜色
#define PDCommonColor RGB(0,145,234)

static NSTimeInterval kPDNetworkingTimeoutSeconds = 20.0f;

static BOOL kOMShouldCache = NO;
static NSTimeInterval kPDCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kPDCacheCountLimit = 1000; // 最多1000条cache

//serviceType
extern NSString *const kMBService;

#endif /* PDNetworkingConfiguration_h */
