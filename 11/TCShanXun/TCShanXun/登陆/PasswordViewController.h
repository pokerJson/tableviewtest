//
//  PasswordViewController.h
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/23.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@interface PasswordViewController : BViewController

@property(nonatomic, copy)NSString * type; //0 修改密码   1 忘记忘记密码
@property(nonatomic, copy)NSString * sign;
@property(nonatomic, copy)NSString * phone;

@end
