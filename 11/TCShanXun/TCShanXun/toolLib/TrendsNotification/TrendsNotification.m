//
//  TrendsNotification.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/9/26.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "TrendsNotification.h"
#import "MineViewController.h"


@implementation TrendsNotification


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


- (void)loadNotification {
    
    if (![UserManager shared].isLogin) return;
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             };
    
    
    [HttpRequest get_RequestWithURL:NOTI_FOLLOWNEWS_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if ([dic[@"data"][@"count"] intValue] != 0) {
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
                    rootVC.myTabBar.subViews[1].dot = YES;
                }
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
    [HttpRequest get_RequestWithURL:NOTI_MESSAGE_URL URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
                if ([dic[@"data"][@"count"] intValue] != 0) {
                    
                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
                    rootVC.myTabBar.subViews[3].dot = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TrendsNotification" object:nil];
                }
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];

    
}

@end
