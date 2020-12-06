//
//  NotiModel.h
//  News
//
//  Created by FANTEXIX on 2018/7/20.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotiModel : NSObject

@property(nonatomic, copy)NSString * userid;

@property(nonatomic, copy)NSString * uid;
@property(nonatomic, copy)NSString * did;
@property(nonatomic, copy)NSString * ID;

@property(nonatomic, copy)NSString * nick;
@property(nonatomic, copy)NSString * icon;
@property(nonatomic, copy)NSString * num_followers;

@property(nonatomic, copy)NSString * if_guanzhu;
@property(nonatomic, copy)NSString * type;
@property(nonatomic, copy)NSString * createtime;

@property(nonatomic, assign)float contentHeight;
@property(nonatomic, assign)float totalHeight;

@end



//{
//    userid = 10007,
//    uid = 10000,
//    did = "",
//    id = 11,
//    userinfo =     {
//        nick = "马玉辉",
//        icon = "http://yzpaipic.ks3-cn-beijing.ksyun.com/icon/jianguo/2018/07/18/16/a79290d4-80f4-4db7-ba84-108c333a7820.jpg",
//        num_followers = 2,
//    },
//    type = 2,
//    createtime = 1532060682000,
//    }
