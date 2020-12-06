//
//  UserManager.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/2.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface UserManager : NSObject

@property(nonatomic, assign)BOOL isLogin;

@property(nonatomic, strong)UserInfo * userInfo;

+ (instancetype)shared;

@end
