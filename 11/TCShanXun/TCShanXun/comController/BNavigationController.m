//
//  BNavigationController.m
//  KanKan
//
//  Created by FANTEXIX on 2016/12/13.
//  Copyright © 2016年 fantexix Inc. All rights reserved.
//

#import "BNavigationController.h"


@interface BNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count == 1) {
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabBarController * rootVC = (MainTabBarController *)app.window.rootViewController;
        rootVC.hideBar = NO;
        rootVC.hideBar = NO;
    }
    
    for (UIView * subview in self.tabBarController.tabBar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            subview.alpha = 0;
        }
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    for (UIView * subview in self.tabBarController.tabBar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            subview.alpha = 0;
        }
    }
}

@end
