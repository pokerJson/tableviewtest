//
//  UserInfo.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/6.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


//用户登录信息
@property(nonatomic, copy)NSString * nick;
@property(nonatomic, copy)NSString * uid;
@property(nonatomic, copy)NSString * signature;
@property(nonatomic, copy)NSString * ifBindPhone;
@property(nonatomic, copy)NSString * refreshToken;
@property(nonatomic, copy)NSString * accessToken;
@property(nonatomic, copy)NSString * expiresIn;
@property(nonatomic, copy)NSString * icon;

@end

//nick = "199****0255",
//uid = 10131,
//signature = "",
//ifBindPhone = 1,
//refreshToken = "cIoRZVvyOf8URgRLImwl-qoHwetfB1Ryx2rJiK-5Gfsc8AKl",
//accessToken = "PeE15cNKM4rjEeUTdsbdgyMqkTxIa9tiV9iEI-2nODtsU6V4",
//expiresIn = 2592000,
//icon = "http://yzpaipic.ks3-cn-beijing.ksyun.com/icon/default/17.jpg",


