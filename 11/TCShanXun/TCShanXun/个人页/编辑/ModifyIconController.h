//
//  ModifyIconController.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/3/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@class PersonModel;
@interface ModifyIconController : BViewController


@property(nonatomic, strong)NSString * type;  //0:背景图 //1:头像

@property(nonatomic, strong)PersonModel * model;

@property(nonatomic, copy)NSString * icon;

@end
