//
//  SysInfo.h
//  KanKan
//
//  Created by FANTEXIX on 2017/7/5.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysInfo : NSObject

+ (NSString *)deviceID;

+ (NSString *)deviceType;
+ (NSString *)sysType;
+ (NSString *)sysVersion;
+ (NSString *)sysLanguage;

+ (NSString *)sysIDFV;
+ (NSString *)sysIDFA;

+ (NSString *)sysWiFiSSID;
+ (NSString *)sysWiFiBSSID;

+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;

+ (NSString *)sysOperator;


@end
