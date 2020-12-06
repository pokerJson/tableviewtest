//
//  UserManager.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/2.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "UserManager.h"
#import "UserInfo.h"

@implementation UserManager

static id _instance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _userInfo = [UserInfo new];
    }
    
    return self;
}

- (UserInfo *)userInfo {
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserLoginInfo"];
    if (dic && dic.count != 0) {
        [_userInfo setValuesForKeysWithDictionary:dic];
    }
    return _userInfo;
}


- (BOOL)isLogin {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN"] boolValue]) {
        _isLogin = YES;
    }else {
        _isLogin = NO;
    }
    
    return _isLogin;
}


@end
