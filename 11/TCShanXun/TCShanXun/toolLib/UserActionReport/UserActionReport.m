//
//  UserActionReport.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/8/3.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "UserActionReport.h"

@implementation UserActionReport

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

- (void)newsPost:(NSString *)newsID ext:(NSString *)ext {
    
    //接口url：
    //参数：
    //play 行为 1 点击消息
    //did 动作操作对象id。点击消息发送消息id
    //ver 1
    //uid 用户id.未登录用户发唯一设备号
    //uploadtime：时间戳
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    if (ext!=nil) [dic setObject:ext forKey:@"ext"];
    
    NSDictionary * param = nil;
    
    if ([UserManager shared].isLogin) {
        param = @{
                  @"play":@"1",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[UserManager shared].userInfo.uid,
                  @"uploadtime":@(time(0)),
                  };
    
    }else {
        param = @{
                  @"play":@"1",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[SysInfo deviceID],
                  @"uploadtime":@(time(0)),
                  };
        
    }
    
    [dic addEntriesFromDictionary:param];
    
    [HttpRequest get_RequestWithURL:USER_ACTION_URL URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
    
}

- (void)sharePost:(NSString *)newsID ext:(NSString *)ext {
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    if (ext!=nil) [dic setObject:ext forKey:@"ext"];
    
    NSDictionary * param = nil;
    if ([UserManager shared].isLogin) {
        param = @{
                  @"play":@"2",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[UserManager shared].userInfo.uid,
                  @"uploadtime":@(time(0)),
                  };
    }else {
        param = @{
                  @"play":@"2",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[SysInfo deviceID],
                  @"uploadtime":@(time(0)),
                  };
    }
    
    [dic addEntriesFromDictionary:param];
    
    [HttpRequest get_RequestWithURL:USER_ACTION_URL URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}


- (void)uninterestedPost:(NSString *)newsID ext:(NSString *)ext {
    
    NSMutableDictionary * dic = @{}.mutableCopy;
    if (ext!=nil) [dic setObject:ext forKey:@"ext"];
    
    NSDictionary * param = nil;
    if ([UserManager shared].isLogin) {
        param = @{
                  @"play":@"5",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[UserManager shared].userInfo.uid,
                  @"uploadtime":@(time(0)),
                  };
    }else {
        param = @{
                  @"play":@"5",
                  @"did":newsID,
                  @"ver":@"1",
                  @"uid":[SysInfo deviceID],
                  @"uploadtime":@(time(0)),
                  };
    }
    
    [dic addEntriesFromDictionary:param];
    
    [HttpRequest get_RequestWithURL:USER_ACTION_URL URLParam:dic returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
}

@end
