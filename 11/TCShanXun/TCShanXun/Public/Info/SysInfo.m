//
//  SysInfo.m
//  KanKan
//
//  Created by FANTEXIX on 2017/7/5.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "SysInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation SysInfo

+ (NSString *)deviceID {
    NSString * deviceUUID = [SAMKeychain passwordForService:@"tcnews"account:@"uuid"];
    if (deviceUUID == nil || [deviceUUID isEqualToString:@""]) {
        NSUUID * UUID  = [UIDevice currentDevice].identifierForVendor;
        deviceUUID = UUID.UUIDString;
        deviceUUID = [deviceUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        deviceUUID = [deviceUUID lowercaseString];
        [SAMKeychain setPassword:deviceUUID forService:@"tcnews"account:@"uuid"];
    }
    return deviceUUID;
}

+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)sysType {
    return [[UIDevice currentDevice] systemName];
}
+ (NSString *)sysVersion {
    return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)sysLanguage {
    return [[NSLocale preferredLanguages] firstObject];
}

+ (NSString *)sysIDFV {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+ (NSString *)sysIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
}

+ (NSString *)sysWiFiSSID {
    
    NSString * wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) return @"";
    
    NSArray * interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString * interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary * networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    
    if (!wifiName) wifiName = @"";
    
    return wifiName;
}

+ (NSString *)sysWiFiBSSID {
    NSString * wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) return @"";
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString * interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary * networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    
    if (!wifiName) wifiName = @"";
    
    return wifiName;
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)sysOperator {
    
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier * carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString * mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        NSLog(@"无SIM卡");
        mobile = @"无SIM卡";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
    
}



@end
