//
//  TopicModel.h
//  News
//
//  Created by FANTEXIX on 2018/7/19.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

@property(nonatomic, copy)NSString * userid;
@property(nonatomic, copy)NSString * num_follow;
@property(nonatomic, copy)NSString * ID;
@property(nonatomic, copy)NSString * category_id;
@property(nonatomic, copy)NSString * des;
@property(nonatomic, copy)NSString * creattime;
@property(nonatomic, copy)NSString * name;
@property(nonatomic, copy)NSString * icon;
@property(nonatomic, copy)NSString * if_guanzhu;
@property(nonatomic, copy)NSString * lasttime;


@end

//if_guanzhu = 0,
//userid = 1,
//num_follow = 4,
//id = 1,
//category_id = 11,
//description = "最新热门",
//creattime = 111111,
//name = "微博热门",
//icon = "http://yzpaipic.ks3-cn-beijing.ksyun.com/icon/default/4.jpg",
