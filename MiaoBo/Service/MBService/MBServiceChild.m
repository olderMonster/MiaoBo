//
//  PDServicePanda.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBServiceChild.h"

@implementation MBServiceChild

#pragma mark -- PDServiceProtocal
//是否线上
- (BOOL)isOnline{
    return YES;
}

//线上的baseurl
- (NSString *)onlineApiBaseUrl{
    return @"http://live.9158.com/";
}

//线上的版本
- (NSString *)onlineApiVersion{
    return @"";
}

- (NSString *)onlinePrivateKey{
    return @"";
}

- (NSString *)onlinePublicKey{
    return @"";
}


- (NSString *)offlineApiBaseUrl{
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey{
    return self.onlinePublicKey;
}

@end
