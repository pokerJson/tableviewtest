/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;

extern NSString *kReachabilityChangedNotification;

@interface Reachability : NSObject

//单例
+ (instancetype)shared;
//网络状态
+ (NetworkStatus)currentStatus;
//是否有网络
+ (BOOL)reachable;
//是否有网络
@property(nonatomic, assign)BOOL reachable;

/******/

//reachabilityWithHostName- Use to check the reachability of a particular host name.
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address.
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.
//Should be used by applications that do not connect to a particular host
+ (instancetype)reachabilityForInternetConnection;

//Start listening for reachability notifications on the current run loop
- (BOOL)startNotifier;
- (void)stopNotifier;

//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL)connectionRequired;

- (NetworkStatus)currentReachabilityStatus;

@end


