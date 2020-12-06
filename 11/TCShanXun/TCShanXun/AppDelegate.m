//
//  AppDelegate.m
//  TCShanXun
//
//  Created by FANTEXIX on 2018/7/25.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ScourceViewController.h"
#import "TopicViewController.h"
#import "TrendsNotification.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [[TrendsNotification shared] loadNotification];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //全局变量
    self.overallParam = @{}.mutableCopy;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[Reachability shared] startNotifier];
    
    self.window.rootViewController = [MainTabBarController new];
    
    [self registerUM];
    
    [self registerForRemoteNotification:launchOptions];
    
    return YES;
}

#pragma mark - UM
- (void)registerUM {
    

    [UMConfigure initWithAppkey:UMAppKey channel:nil];
    
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPKEY  appSecret:QQAPPSECRET redirectURL:nil];
    
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPKEY appSecret:WXAPPSECRET redirectURL:nil];
    
    //新浪
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINAAPPKEY  appSecret:SINAAPPSECRET redirectURL:SINAREDIRECTURL];
    
}

#pragma mark - UM_推送
- (void)registerForRemoteNotification:(NSDictionary *)launchOptions {


    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if (@available(iOS 10.0, *)) [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:[[UMessageRegisterEntity alloc] init] completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"允许推送");
        }else {
            NSLog(@"拒绝推送");
        }
    }];
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * dt = [[[deviceToken description] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>"]] componentsJoinedByString:@""];
    NSLog(@"deviceToken: %@", dt);
    
    
    
    NSDictionary * param = nil;
    
    if ([UserManager shared].isLogin) {
        param = @{
                  @"DeviceToken":dt,
                  @"userid":[UserManager shared].userInfo.uid,
                  };
    }else {
        param = @{
                  @"DeviceToken":dt,
                  };
    }

    [HttpRequest get_RequestWithURL:DEVICETOKEN URLParam:param returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {
                
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }
    }];
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dt forKey:@"deviceToken"];
    [userDefaults synchronize];
    
}

//iOS10：前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10接收远程推送: %@",userInfo);
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        NSLog(@"iOS10接收本地推送: %@",userInfo);
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10：点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10点击远程推送: %@",userInfo);
        //友盟
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self handNotification:userInfo];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSLog(@"前台点击");
            [UMessage sendClickReportForRemoteNotification:userInfo];
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    }else{
        NSLog(@"iOS10点击本地推送: %@",userInfo);
    }
    completionHandler();
}

//iOS9/8 远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {

    [UMessage setAutoAlert:NO];//关闭友盟自带的弹出框
    [UMessage didReceiveRemoteNotification:userInfo];

    if (application.applicationState != UIApplicationStateActive) {
        NSLog(@"iOS 9/8 后台接收 : %@",userInfo);
        //友盟
        [self handNotification:userInfo];
        
    }else {

        NSLog(@"iOS 9/8 活跃接收: %@",userInfo);
        NSString * m = userInfo[@"m"];
        
        if (m && [m isEqualToString:@"mute"]) {
            
            NSString * num = userInfo[@"num"];
            if (num) {
                NSLog(@"静默推送");
                //content-available = 1,
                
            }
        }else {
            
            UILocalNotification * notification = [[UILocalNotification alloc]init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
            notification.repeatInterval = 0;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber = [userInfo[@"aps"][@"badge"] intValue];
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.userInfo = userInfo;
            id alert = userInfo[@"aps"][@"alert"];
            if (alert) {
                if ([alert isKindOfClass:[NSString class]]) {
                    notification.alertBody = alert;
                }else if ([alert isKindOfClass:[NSDictionary class]]) {
                    NSString * body = alert[@"body"];
                    if (body) notification.alertBody = body;
                }
            }
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }

    completionHandler(UIBackgroundFetchResultNewData);
}
//本地推送处理
- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState != UIApplicationStateActive) {
        NSLog(@"iOS 9/8 后台点击: %@",notification.userInfo);
        //友盟
        [self handNotification:notification.userInfo];
        [UMessage sendClickReportForRemoteNotification:notification.userInfo];
    }
}


- (void)handNotification:(NSDictionary *)param {
    
    UITabBarController * rootVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController * currentNavVC = rootVC.selectedViewController;
    
    if ([param[@"type"] isEqualToString:@"news"]) {
        
        ScourceViewController * vc = [[ScourceViewController alloc]init];
        vc.ID = param[@"param"];
        vc.hidesBottomBarWhenPushed = YES;
        [currentNavVC pushViewController:vc animated:YES];
        
    }else if ([param[@"type"] isEqualToString:@"topic"]) {
        
        TopicViewController * vc = [[TopicViewController alloc]init];
        vc.topicID = param[@"param"];
        vc.hidesBottomBarWhenPushed = YES;
        [currentNavVC pushViewController:vc animated:YES];
    }
    
}


- (void)handleUrl:(NSURL *)url {
    NSString * urlStr = url.absoluteString;
    
    if ([urlStr hasPrefix:@"shanxunlauncher://"]) {
        //首页
        
        UITabBarController * rootVC = (UITabBarController *)self.window.rootViewController;
        [rootVC setSelectedIndex:0];
        
        NSRange range;
        if ([urlStr isEqualToString:@"shanxunlauncher://"]) {
            
        }
        //新闻
        range = [urlStr rangeOfString:@"news?id="];
        if (range.location != NSNotFound) {
            NSString * ID = [urlStr substringFromIndex:range.location+range.length];
        
            UINavigationController * currentNavVC = rootVC.selectedViewController;
            ScourceViewController * vc = [[ScourceViewController alloc]init];
            vc.ID = ID;
            vc.hidesBottomBarWhenPushed = YES;
            [currentNavVC pushViewController:vc animated:YES];
            
        }
        //主题
        range = [urlStr rangeOfString:@"topic?id="];
        if (range.location != NSNotFound) {
            NSString * ID = [urlStr substringFromIndex:range.location+range.length];
            
            UINavigationController * currentNavVC = rootVC.selectedViewController;
            TopicViewController * vc = [[TopicViewController alloc]init];
            vc.topicID = ID;
            vc.hidesBottomBarWhenPushed = YES;
            [currentNavVC pushViewController:vc animated:YES];
        }
    }
    
    
}


//iOS 9 and later
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"iOS 9 later url.absoluteString: %@",url.absoluteString);
    [self handleUrl:url];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}

//iOS 8
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"iOS 8 url.absoluteString: %@",url.absoluteString);
    [self handleUrl:url];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}


@end
