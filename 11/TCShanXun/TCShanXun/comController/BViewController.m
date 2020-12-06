//
//  BViewController.m
//  KanKan
//
//  Created by FANTEXIX on 2016/12/13.
//  Copyright © 2016年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()

@end

@implementation BViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.view.clipsToBounds = YES;

    [self createNavView];
}


- (void)createNavView {
    //navBar
    _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kStatusHeight+44)];
    _navBarView.hidden = YES;
    [self.view addSubview:_navBarView];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, kStatusHeight, kWidth - 150, 44)];
    _navTitleLabel.text = self.title;
    _navTitleLabel.textAlignment = 1;
    [_navBarView addSubview:_navTitleLabel];
    
    _navLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(5, kStatusHeight, 44, 44)];
    [_navLeftButton addTarget:self action:@selector(leftButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:_navLeftButton];
    
    _navRightButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 49, kStatusHeight, 44, 44)];
    [_navRightButton addTarget:self action:@selector(rightButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:_navRightButton];
    
    _navShadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, _navBarView.bounds.size.height-0.4, kWidth, 0.4)];
    _navShadowLine.backgroundColor = RGBColor(170, 170, 170);
    [_navBarView addSubview:_navShadowLine];
}


- (void)leftButtonMethod:(UIButton *)button {
    if ([self respondsToSelector:@selector(navLeftMethod:)]) {
        [self navLeftMethod:button];
    }
}

- (void)navLeftMethod:(UIButton *)button {

}


- (void)rightButtonMethod:(UIButton *)button {
    if ([self respondsToSelector:@selector(navRightMethod:)]) {
        [self navRightMethod:button];
    }
}

- (void)navRightMethod:(UIButton *)button {
    
}

- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = toInterfaceOrientation;
        // 从2开始是因为0 1两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
